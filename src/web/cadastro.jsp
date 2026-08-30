<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    ============================================================
    FormZAP - Fase 2 | Pessoa 2 (Iris) - VISAO
    Ficheiro: cadastro.jsp

    ATUALIZACAO (separacao Criar vs Pesquisar/Alterar):
    Esta pagina passou a servir APENAS o fluxo de CRIAR um novo
    fornecedor. Ja nao tem barra de busca por NIF nem o seletor de
    "Tipo de operacao" - quem entra aqui ja escolheu "Novo
    Fornecedor" no menu, por isso tipoOperacao segue directo como
    campo escondido com o valor "Criar".

    O fluxo de Alterar/Eliminar (busca por NIF + cartao do
    fornecedor com os icones de Editar/Eliminar) passou para
    pesquisar.jsp - ver esse ficheiro.

    IMPORTANTE PARA O GRUPO (inalterado):
    - O <form> envia para o Servlet mapeado em "/cadastro"
      (Pessoa 3 - Jonilson), agora sempre com tipoOperacao="Criar".
    - Os nomes dos campos seguem a seccao 4 do documento mestre
      (contrato oficial) - nada mudou aqui.
    - Campo escondido "dataOperacao" (data actual em formato ISO)
      mantido porque o Servlet le request.getParameter("dataOperacao").
    - Em caso de erro de validacao (ex.: NIF duplicado), o Servlet
      deve continuar a reencaminhar (forward, nao redirect) de volta
      para esta pagina com request.setAttribute("erro", "...") e os
      parametros preenchidos, exactamente como antes.
    ============================================================
--%>
<%!
    private String nz(Object valor) {
        return (valor == null) ? "" : valor.toString();
    }
%>
<%
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

    String dataOperacaoIso = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    java.text.SimpleDateFormat sdfExtenso = new java.text.SimpleDateFormat(
            "EEEE, d 'de' MMMM 'de' yyyy", new java.util.Locale("pt", "PT"));
    String dataHojeExtenso = sdfExtenso.format(new java.util.Date());

    Object erro = request.getAttribute("erro");

    // Variaveis lidas por includes/cabecalho.jspf e includes/rodape.jspf
    String paginaAtual = "cadastro";
    String tituloPagina = "Novo Fornecedor";
    String subtituloPagina = "Criar um registo do zero";
    String toastMensagem = null;
    String toastTipo = null;
%>
<%@ include file="includes/cabecalho.jspf" %>

                <div class="folha">
                    <div class="cabecalho-cartao">
                        <img src="<%= request.getContextPath() %>/images/ZAP2.png" alt="ZAP">
                        <div>
                            <p class="titulo-form">Novo Fornecedor</p>
                            <p class="subtitulo-form">Preencha os dados abaixo para criar um registo</p>
                        </div>
                    </div>

                    <% if (erro != null) { %>
                    <div class="mensagem mensagem-erro" role="alert">
                        <span class="icone" aria-hidden="true">&#9888;</span>
                        <span><strong>Atencao:</strong> <%= erro %></span>
                    </div>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/cadastro" method="post"
                          autocomplete="off" data-loading="true" novalidate>

                        <input type="hidden" name="tipoOperacao" value="Criar">
                        <input type="hidden" name="dataOperacao" value="<%= dataOperacaoIso %>">

                        <div class="linha-topo">
                            <p class="texto-ajuda" style="margin:0;">A criar um novo fornecedor.</p>
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
                                <span>Salvar Cadastro</span>
                            </button>
                        </div>
                    </form>
                </div>

<%@ include file="includes/rodape.jspf" %>