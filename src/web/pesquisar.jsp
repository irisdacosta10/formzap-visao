<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Fornecedor" %>
<%--
    ============================================================
    FormZAP - Fase 2 | Pessoa 2 (Iris) - VISAO
    Ficheiro: pesquisar.jsp

    NOVO FICHEIRO (fluxo separado de Alterar/Eliminar).

    Antes, a busca por NIF e o formulario de Alterar/Eliminar viviam
    dentro de cadastro.jsp (com um seletor "Tipo de operacao"
    visivel). Passaram para aqui, com um fluxo mais directo:

        1) O utilizador procura pelo NIF.
        2) Se nao encontrar, ve uma mensagem simples e pode tentar
           outra vez.
        3) Se encontrar, ve um "cartao" com os dados principais do
           fornecedor e DOIS icones: Editar e Eliminar. O
           tipoOperacao deixa de ser uma escolha do utilizador -
           passa a ser um campo escondido, definido pela accao que
           ele clicou (Alterar ao clicar "Editar", Eliminar ao
           clicar "Eliminar" e confirmar).

    IMPORTANTE PARA O GRUPO (coordenar com Pessoa 3 - Jonilson):
    Isto e so a Visao, mas duas rotas do lado do Servlet passam a
    apontar para ESTE ficheiro em vez de cadastro.jsp:

      a) BuscarServlet ("/buscar"): o forward de sucesso/aviso
         (request.setAttribute("fornecedor", f) OU
         request.setAttribute("avisoBusca", "NIF nao encontrado"))
         deve reencaminhar para "pesquisar.jsp" - antes ia para
         "cadastro.jsp". E so mudar o destino do forward, os nomes
         dos atributos continuam os mesmos.

      b) CadastroServlet ("/cadastro", POST): quando tipoOperacao
         for "Alterar" ou "Eliminar" e a validacao falhar, o forward
         de erro (request.setAttribute("erro", "...")) tambem deve
         ir para "pesquisar.jsp" em vez de "cadastro.jsp". Quando
         tipoOperacao for "Criar", continua a ir para "cadastro.jsp"
         como ja acontecia.

    Fora isso, os nomes dos campos, o endpoint "/cadastro" e os
    valores de tipoOperacao ("Criar" | "Alterar" | "Eliminar")
    continuam exactamente iguais - nada do contrato com o Bean/DAO
    muda.

    NOVO - modo so-leitura ("Ver"): o BuscarServlet agora tambem
    deixa o atributo booleano "modoSomenteLeitura". Quando vem a
    true (utilizador clicou em "Ver" na listagem, nao em "Alterar"),
    esta pagina mostra o cartao do fornecedor JA COM TODOS OS
    CAMPOS visiveis, sem o formulario de edicao nem os botoes
    Editar/Eliminar - so um link para voltar a listagem. Quando
    vem false ou nao vem definido (link "Alterar", ou apos um erro
    de validacao), o comportamento e exactamente o mesmo de sempre.
    ============================================================
--%>
<%!
    private String nz(Object valor) {
        return (valor == null) ? "" : valor.toString();
    }
%>
<%
    // BuscarServlet deixa aqui o fornecedor encontrado (fluxo feliz).
    Fornecedor fEncontrado = (Fornecedor) request.getAttribute("fornecedor");

    Object avisoBusca = request.getAttribute("avisoBusca"); // ex.: "NIF nao encontrado"
    Object erro = request.getAttribute("erro"); // validacao falhou num Alterar/Eliminar

    Object modoSomenteLeituraAttr = request.getAttribute("modoSomenteLeitura");
    boolean modoSomenteLeitura = (modoSomenteLeituraAttr != null) && (Boolean) modoSomenteLeituraAttr;

    String[] nomesCampos = {
        "nome", "morada", "pais", "provinciaDistrito", "municipioConcelho",
        "website", "ramoActividade", "telefone", "nif", "condicaoPagamento",
        "paisBanco", "banco", "iban", "numeroConta", "swift",
        "areaContacto", "nomeContacto", "telefoneContacto", "funcaoContacto", "email"
    };
    java.util.Map<String, String> v = new java.util.HashMap<String, String>();
    for (String c : nomesCampos) {
        v.put(c, nz(request.getParameter(c)));
    }

    if (fEncontrado != null) {
        v.put("nome", nz(fEncontrado.getNome()));
        v.put("morada", nz(fEncontrado.getMorada()));
        v.put("pais", nz(fEncontrado.getPais()));
        v.put("provinciaDistrito", nz(fEncontrado.getProvinciaDistrito()));
        v.put("municipioConcelho", nz(fEncontrado.getMunicipioConcelho()));
        v.put("website", nz(fEncontrado.getWebsite()));
        v.put("ramoActividade", nz(fEncontrado.getRamoActividade()));
        v.put("telefone", nz(fEncontrado.getTelefone()));
        v.put("nif", nz(fEncontrado.getNif()));
        v.put("condicaoPagamento", nz(fEncontrado.getCondicaoPagamento()));
        v.put("paisBanco", nz(fEncontrado.getPaisBanco()));
        v.put("banco", nz(fEncontrado.getBanco()));
        v.put("iban", nz(fEncontrado.getIban()));
        v.put("numeroConta", nz(fEncontrado.getNumeroConta()));
        v.put("swift", nz(fEncontrado.getSwift()));
        v.put("areaContacto", nz(fEncontrado.getAreaContacto()));
        v.put("nomeContacto", nz(fEncontrado.getNomeContacto()));
        v.put("telefoneContacto", nz(fEncontrado.getTelefoneContacto()));
        v.put("funcaoContacto", nz(fEncontrado.getFuncaoContacto()));
        v.put("email", nz(fEncontrado.getEmail()));
    }

    // Ha "resultado" para mostrar (cartao + painel de edicao) quando
    // encontramos um fornecedor OU quando voltamos de um Alterar que
    // falhou a validacao (erro != null, com os parametros preenchidos).
    boolean temResultado = (fEncontrado != null) || (erro != null);

    // O painel de edicao comeca aberto se ja houver um erro para
    // corrigir; caso contrario comeca fechado (o utilizador escolhe
    // clicar em "Editar"). Em modo so-leitura, o painel nunca abre.
    boolean painelAberto = (erro != null) && !modoSomenteLeitura;

    String dataOperacaoIso = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    java.text.SimpleDateFormat sdfExtenso = new java.text.SimpleDateFormat(
            "EEEE, d 'de' MMMM 'de' yyyy", new java.util.Locale("pt", "PT"));
    String dataHojeExtenso = sdfExtenso.format(new java.util.Date());

    // Variaveis lidas por includes/cabecalho.jspf e includes/rodape.jspf
    String paginaAtual = "pesquisar";
    String tituloPagina = "Pesquisar / Alterar";
    String subtituloPagina = "Procure um fornecedor pelo NIF";
    String toastMensagem = null;
    String toastTipo = null;
%>
<%@ include file="includes/cabecalho.jspf" %>

                <div class="folha">
                    <div class="cabecalho-cartao">
                        <img src="<%= request.getContextPath() %>/images/ZAP2.png" alt="ZAP">
                        <div>
                            <p class="titulo-form">Pesquisar / Alterar</p>
                            <p class="subtitulo-form">Procure um fornecedor pelo NIF para alterar ou eliminar o registo</p>
                        </div>
                    </div>

                    <% if (erro != null) { %>
                    <div class="mensagem mensagem-erro" role="alert">
                        <span class="icone" aria-hidden="true">&#9888;</span>
                        <span><strong>Atencao:</strong> <%= erro %></span>
                    </div>
                    <% } %>

                    <% if (avisoBusca != null) { %>
                    <div class="mensagem mensagem-aviso" role="alert">
                        <span class="icone" aria-hidden="true">&#8505;</span>
                        <span><%= avisoBusca %></span>
                    </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/buscar" method="get"
                          class="busca-nif" aria-label="Procurar fornecedor por NIF" data-loading="true">
                        <p class="texto-ajuda">Escreva o NIF do fornecedor que quer alterar ou eliminar.</p>
                        <div class="campo">
                            <label for="buscaNif">NIF do fornecedor a procurar</label>
                            <input type="text" id="buscaNif" name="nif" required
                                   aria-describedby="buscaNifAjuda" value="<%= v.get("nif") %>">
                            <small id="buscaNifAjuda" class="ajuda-campo">Campo obrigatorio para esta busca</small>
                        </div>
                        <button type="submit" class="btn btn-primario">
                            <span class="icone" aria-hidden="true">&#128269;</span>
                            <span>Procurar</span>
                        </button>
                    </form>

<%
    if (temResultado && modoSomenteLeitura && fEncontrado != null) {
%>
                    <div class="cartao-fornecedor">
                        <div class="cartao-fornecedor__cabecalho">
                            <div>
                                <p class="cartao-fornecedor__nome"><%= v.get("nome").isEmpty() ? "Fornecedor" : v.get("nome") %></p>
                                <span class="badge">NIF: <%= v.get("nif") %></span>
                            </div>
                            <div class="cartao-fornecedor__acoes">
                                <a href="<%= request.getContextPath() %>/listar" class="btn btn-secundario">
                                    <span class="icone" aria-hidden="true">&#8592;</span>
                                    <span>Voltar a listagem</span>
                                </a>
                            </div>
                        </div>
                        <div class="cartao-fornecedor__dados cartao-fornecedor__dados--completo">
                            <div>
                                <span class="cartao-fornecedor__rotulo">Morada</span>
                                <span><%= v.get("morada").isEmpty() ? "-" : v.get("morada") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Pais</span>
                                <span><%= v.get("pais").isEmpty() ? "-" : v.get("pais") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Provincia / Distrito</span>
                                <span><%= v.get("provinciaDistrito").isEmpty() ? "-" : v.get("provinciaDistrito") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Municipio / Concelho</span>
                                <span><%= v.get("municipioConcelho").isEmpty() ? "-" : v.get("municipioConcelho") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Website</span>
                                <span><%= v.get("website").isEmpty() ? "-" : v.get("website") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Ramo de Actividade</span>
                                <span><%= v.get("ramoActividade").isEmpty() ? "-" : v.get("ramoActividade") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Telefone</span>
                                <span><%= v.get("telefone").isEmpty() ? "-" : v.get("telefone") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Condicao de Pagamento</span>
                                <span><%= v.get("condicaoPagamento").isEmpty() ? "-" : v.get("condicaoPagamento") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Pais do Banco</span>
                                <span><%= v.get("paisBanco").isEmpty() ? "-" : v.get("paisBanco") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Banco</span>
                                <span><%= v.get("banco").isEmpty() ? "-" : v.get("banco") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">IBAN</span>
                                <span><%= v.get("iban").isEmpty() ? "-" : v.get("iban") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Numero de Conta</span>
                                <span><%= v.get("numeroConta").isEmpty() ? "-" : v.get("numeroConta") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">SWIFT</span>
                                <span><%= v.get("swift").isEmpty() ? "-" : v.get("swift") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Area de Contacto</span>
                                <span><%= v.get("areaContacto").isEmpty() ? "-" : v.get("areaContacto") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Nome do Contacto</span>
                                <span><%= v.get("nomeContacto").isEmpty() ? "-" : v.get("nomeContacto") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Telefone do Contacto</span>
                                <span><%= v.get("telefoneContacto").isEmpty() ? "-" : v.get("telefoneContacto") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Funcao do Contacto</span>
                                <span><%= v.get("funcaoContacto").isEmpty() ? "-" : v.get("funcaoContacto") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">E-mail</span>
                                <span><%= v.get("email").isEmpty() ? "-" : v.get("email") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Data de Cadastro</span>
                                <span><%= fEncontrado.getDataCadastro() == null ? "-" : fEncontrado.getDataCadastro() %></span>
                            </div>
                        </div>
                    </div>
<%
    } else if (temResultado) {
%>
                    <div class="cartao-fornecedor">
                        <div class="cartao-fornecedor__cabecalho">
                            <div>
                                <p class="cartao-fornecedor__nome"><%= v.get("nome").isEmpty() ? "Fornecedor" : v.get("nome") %></p>
                                <span class="badge">NIF: <%= v.get("nif") %></span>
                            </div>
                            <div class="cartao-fornecedor__acoes">
                                <button type="button" id="btnEditarFornecedor" class="btn btn-secundario"
                                        aria-expanded="<%= painelAberto ? "true" : "false" %>"
                                        aria-controls="painelEdicaoFornecedor">
                                    <span class="icone" aria-hidden="true">&#9998;</span>
                                    <span>Editar</span>
                                </button>
                                <form action="<%= request.getContextPath() %>/cadastro" method="post"
                                      data-loading="true"
                                      data-confirmar="Tem a certeza que quer eliminar o fornecedor '<%= v.get("nome") %>'? Esta accao nao pode ser desfeita.">
                                    <input type="hidden" name="tipoOperacao" value="Eliminar">
                                    <input type="hidden" name="nif" value="<%= v.get("nif") %>">
                                    <button type="submit" class="btn btn-perigo">
                                        <span class="icone" aria-hidden="true">&#128465;</span>
                                        <span>Eliminar</span>
                                    </button>
                                </form>
                            </div>
                        </div>
                        <div class="cartao-fornecedor__dados">
                            <div>
                                <span class="cartao-fornecedor__rotulo">Telefone</span>
                                <span><%= v.get("telefone").isEmpty() ? "-" : v.get("telefone") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">E-mail</span>
                                <span><%= v.get("email").isEmpty() ? "-" : v.get("email") %></span>
                            </div>
                            <div>
                                <span class="cartao-fornecedor__rotulo">Pais</span>
                                <span><%= v.get("pais").isEmpty() ? "-" : v.get("pais") %></span>
                            </div>
                        </div>
                    </div>

                    <div id="painelEdicaoFornecedor" class="painel-edicao" <%= painelAberto ? "" : "hidden" %>>
                        <form action="<%= request.getContextPath() %>/cadastro" method="post"
                              autocomplete="off" data-loading="true" novalidate>

                            <input type="hidden" name="tipoOperacao" value="Alterar">
                            <input type="hidden" name="dataOperacao" value="<%= dataOperacaoIso %>">

                            <div class="linha-topo">
                                <p class="texto-ajuda" style="margin:0;">A alterar este fornecedor.</p>
                                <div class="data-cadastro">
                                    <label for="dataVisivel">Data:</label>
                                    <input type="text" id="dataVisivel" value="<%= dataHojeExtenso %>" readonly size="34">
                                </div>
                            </div>

                            <fieldset class="seccao-form">
                                <legend>Dados Gerais do Fornecedor</legend>
                                <p class="nota-seccao">Campos de preenchimento obrigatorio</p>
                                <div class="grid">
                                    <div class="campo campo largo">
                                        <label for="nome">Designacao Social <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="text" id="nome" name="nome" required value="<%= v.get("nome") %>">
                                    </div>
                                    <div class="campo largo">
                                        <label for="morada">Morada <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="text" id="morada" name="morada" required value="<%= v.get("morada") %>">
                                    </div>
                                    <div class="campo">
                                        <label for="pais">Pais <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <select id="pais" name="pais" required>
                                            <option value="">Seleccione...</option>
                                            <option value="Angola" <%= "Angola".equals(v.get("pais")) ? "selected" : "" %>>Angola</option>
                                            <option value="Mocambique" <%= "Mocambique".equals(v.get("pais")) ? "selected" : "" %>>Mocambique</option>
                                            <option value="Portugal" <%= "Portugal".equals(v.get("pais")) ? "selected" : "" %>>Portugal</option>
                                        </select>
                                    </div>
                                    <div class="campo">
                                        <label for="provinciaDistrito">Provincia (AO e MZ) / Distrito (PT) <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="text" id="provinciaDistrito" name="provinciaDistrito" required value="<%= v.get("provinciaDistrito") %>">
                                    </div>
                                    <div class="campo">
                                        <label for="municipioConcelho">Municipio (AO e MZ) / Concelho (PT) <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="text" id="municipioConcelho" name="municipioConcelho" required value="<%= v.get("municipioConcelho") %>">
                                    </div>
                                    <div class="campo">
                                        <label for="website">Website</label>
                                        <input type="text" id="website" name="website"
                                               placeholder="https://www.exemplo.com"
                                               aria-describedby="websiteAjuda"
                                               value="<%= v.get("website") %>">
                                        <small id="websiteAjuda" class="ajuda-campo">Opcional. Inclua http:// ou https://</small>
                                    </div>
                                    <div class="campo">
                                        <label for="ramoActividade">Ramo de Actividade <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="text" id="ramoActividade" name="ramoActividade" required value="<%= v.get("ramoActividade") %>">
                                    </div>
                                    <div class="campo">
                                        <label for="telefone">Telefone <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="tel" id="telefone" name="telefone" required
                                               aria-describedby="telefoneAjuda"
                                               value="<%= v.get("telefone") %>">
                                        <small id="telefoneAjuda" class="ajuda-campo">Seleccione o pais para ver um exemplo.</small>
                                    </div>
                                    <div class="campo">
                                        <label for="nif">NIF <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="text" id="nif" name="nif" required
                                               aria-describedby="nifAjuda"
                                               value="<%= v.get("nif") %>">
                                        <small id="nifAjuda" class="ajuda-campo">Seleccione o pais para ver um exemplo.</small>
                                    </div>
                                    <div class="campo">
                                        <label for="condicaoPagamento">Condicao de Pagamento</label>
                                        <select id="condicaoPagamento" name="condicaoPagamento">
                                            <option value="P001" <%= v.get("condicaoPagamento").equals("P001") ? "selected" : "" %>>P001 - Pagamento a 30 dias s/ desconto</option>
                                            <option value="P002" <%= v.get("condicaoPagamento").equals("P002") ? "selected" : "" %>>P002 - Pagamento a 60 dias s/ desconto</option>
                                            <option value="P003" <%= v.get("condicaoPagamento").equals("P003") ? "selected" : "" %>>P003 - Pronto pagamento</option>
                                        </select>
                                    </div>
                                </div>
                            </fieldset>

                            <fieldset class="seccao-form">
                                <legend>Dados Bancarios do Fornecedor</legend>
                                <p class="nota-seccao">Obrigatorio o preenchimento de um IBAN como principal</p>
                                <div class="grid-3">
                                    <div class="campo">
                                        <label for="paisBanco">Pais <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <select id="paisBanco" name="paisBanco" required>
                                            <option value="">Seleccione...</option>
                                            <option value="Angola" <%= "Angola".equals(v.get("paisBanco")) ? "selected" : "" %>>Angola</option>
                                            <option value="Mocambique" <%= "Mocambique".equals(v.get("paisBanco")) ? "selected" : "" %>>Mocambique</option>
                                            <option value="Portugal" <%= "Portugal".equals(v.get("paisBanco")) ? "selected" : "" %>>Portugal</option>
                                        </select>
                                    </div>
                                    <div class="campo">
                                        <label for="banco">Nome do Banco <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="text" id="banco" name="banco" required value="<%= v.get("banco") %>">
                                    </div>
                                    <div class="campo">
                                        <label for="swift">SWIFT</label>
                                        <input type="text" id="swift" name="swift"
                                               aria-describedby="swiftAjuda"
                                               value="<%= v.get("swift") %>">
                                        <small id="swiftAjuda" class="ajuda-campo">Seleccione o pais do banco para ver um exemplo.</small>
                                    </div>
                                    <div class="campo largo">
                                        <label for="iban">IBAN <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="text" id="iban" name="iban" required
                                               aria-describedby="ibanAjuda"
                                               value="<%= v.get("iban") %>">
                                        <small id="ibanAjuda" class="ajuda-campo">Seleccione o pais do banco para ver um exemplo.</small>
                                    </div>
                                    <div class="campo">
                                        <label for="numeroConta">Numero de Conta</label>
                                        <input type="text" id="numeroConta" name="numeroConta"
                                               aria-describedby="numeroContaAjuda"
                                               value="<%= v.get("numeroConta") %>">
                                        <small id="numeroContaAjuda" class="ajuda-campo">Apenas digitos (6 a 20 caracteres)</small>
                                    </div>
                                </div>
                            </fieldset>

                            <fieldset class="seccao-form">
                                <legend>Dados para Contacto</legend>
                                <p class="nota-seccao">Obrigatorio o preenchimento de um contacto da Direccao Financeira do Fornecedor</p>
                                <div class="grid-3">
                                    <div class="campo">
                                        <label for="areaContacto">Area</label>
                                        <input type="text" id="areaContacto" name="areaContacto"
                                               value="<%= v.get("areaContacto").isEmpty() ? "Financeira" : v.get("areaContacto") %>">
                                    </div>
                                    <div class="campo">
                                        <label for="nomeContacto">Nome <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="text" id="nomeContacto" name="nomeContacto" required value="<%= v.get("nomeContacto") %>">
                                    </div>
                                    <div class="campo">
                                        <label for="telefoneContacto">Telefone <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="tel" id="telefoneContacto" name="telefoneContacto" required
                                               aria-describedby="telefoneContactoAjuda"
                                               value="<%= v.get("telefoneContacto") %>">
                                        <small id="telefoneContactoAjuda" class="ajuda-campo">Seleccione o pais para ver um exemplo.</small>
                                    </div>
                                    <div class="campo largo">
                                        <label for="funcaoContacto">Funcao</label>
                                        <input type="text" id="funcaoContacto" name="funcaoContacto" value="<%= v.get("funcaoContacto") %>">
                                    </div>
                                    <div class="campo largo">
                                        <label for="email">Endereco de E-mail <span class="obrigatorio" aria-hidden="true">*</span></label>
                                        <input type="email" id="email" name="email" required
                                               aria-describedby="emailAjuda"
                                               value="<%= v.get("email") %>">
                                        <small id="emailAjuda" class="ajuda-campo">Ex.: nome@empresa.com</small>
                                    </div>
                                </div>
                            </fieldset>

                            <div class="acoes">
                                <button type="reset" class="btn btn-secundario">
                                    <span class="icone" aria-hidden="true">&#8635;</span>
                                    <span>Limpar</span>
                                </button>
                                <button type="submit" class="btn btn-primario">
                                    <span class="icone" aria-hidden="true">&#128190;</span>
                                    <span>Guardar Alteracoes</span>
                                </button>
                            </div>
                        </form>
                    </div>
<%
    }
%>
                </div>

<%@ include file="includes/rodape.jspf" %>
