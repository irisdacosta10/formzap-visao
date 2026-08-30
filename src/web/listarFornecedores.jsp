<%@ page contentType="text/html;charset=UTF-8" language="java"
    import="java.util.List, model.Fornecedor" %>
<%--
    ============================================================
    FormZAP - Fase 2 | Pessoa 2 (Iris) - VISAO
    Ficheiro: listarFornecedores.jsp

    Esta pagina espera ser alcancada via FORWARD a partir do
    ListarServlet (rota "/listar", Pessoa 3), que deve deixar a
    lista pronta com:
        request.setAttribute("listaFornecedores", dao.listarTodos());
        request.getRequestDispatcher("listarFornecedores.jsp").forward(request, response);
    Aceder directamente a este ficheiro .jsp (sem passar pelo
    Servlet) mostra sempre o estado "vazio", porque o atributo
    "listaFornecedores" nao existe. Por isso os links de navegacao
    da aplicacao apontam para "listar" (a rota), nunca para este
    ficheiro directamente.

    Accao de Eliminar: por seguranca (accao que altera dados nunca
    deve ser um simples link GET), cada linha tem um mini-formulario
    POST para /cadastro com tipoOperacao=Eliminar, confirmado com
    JavaScript (ver js/app.js) antes de ser enviado.

    Accao de Alterar: o link "Alterar" continua a chamar "/buscar"
    (BuscarServlet, Pessoa 3) - so muda o destino do forward do lado
    do Servlet, que agora deve reencaminhar para pesquisar.jsp em vez
    de cadastro.jsp (ver o comentario no topo de pesquisar.jsp).

    Accao de Ver (NOVO): link "Ver", que tambem chama "/buscar", mas
    com o parametro extra "modo=ver". O BuscarServlet reconhece este
    parametro e diz a pesquisar.jsp para mostrar o fornecedor em modo
    so-leitura (todos os campos visiveis, sem formulario de edicao) -
    ver o comentario no topo de pesquisar.jsp para o detalhe.
    ============================================================
--%>
<%
    List<Fornecedor> lista = (List<Fornecedor>) request.getAttribute("listaFornecedores");
    int total = (lista != null) ? lista.size() : 0;

    String paginaAtual = "listar";
    String tituloPagina = "Fornecedores Cadastrados";
    String subtituloPagina = total + " fornecedor(es) encontrado(s)";
    String toastMensagem = null;
    String toastTipo = null;
%>
<%@ include file="includes/cabecalho.jspf" %>

                <div class="folha">
                    <div class="cabecalho-cartao">
                        <img src="<%= request.getContextPath() %>/images/ZAP2.png" alt="ZAP">
                        <div>
                            <p class="titulo-form">Fornecedores Cadastrados</p>
                            <p class="subtitulo-form">Consulte, altere ou elimine fornecedores existentes</p>
                        </div>
                    </div>

                    <div class="acoes" style="justify-content:space-between; margin-bottom:18px;">
                        <span class="badge"><%= total %> fornecedor<%= total == 1 ? "" : "es" %></span>
                        <a href="<%= request.getContextPath() %>/cadastro.jsp" class="btn btn-primario">
                            <span class="icone" aria-hidden="true">&#10133;</span>
                            <span>Novo Fornecedor</span>
                        </a>
                    </div>

<%
    if (lista == null || lista.isEmpty()) {
%>
                    <div class="estado-vazio">
                        <div class="icone-vazio" aria-hidden="true">&#128203;</div>
                        <p><strong>Ainda nao ha fornecedores cadastrados.</strong></p>
                        <p>Comece por criar o primeiro registo.</p>
                        <a href="<%= request.getContextPath() %>/cadastro.jsp" class="btn btn-primario">Criar Fornecedor</a>
                    </div>
<%
    } else {
%>
                    <div class="tabela-wrapper">
                        <table class="lista">
                            <caption class="visualmente-oculto">Lista de fornecedores cadastrados, com acoes de alterar e eliminar</caption>
                            <thead>
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">Designacao Social</th>
                                    <th scope="col">NIF</th>
                                    <th scope="col">Telefone</th>
                                    <th scope="col">E-mail</th>
                                    <th scope="col">Pais</th>
                                    <th scope="col">Data Cadastro</th>
                                    <th scope="col">Accoes</th>
                                </tr>
                            </thead>
                            <tbody>
<%
        for (Fornecedor f : lista) {
%>
                                <tr>
                                    <td><%= f.getId() %></td>
                                    <td><%= f.getNome() %></td>
                                    <td><%= f.getNif() %></td>
                                    <td><%= f.getTelefone() %></td>
                                    <td><%= f.getEmail() %></td>
                                    <td><%= f.getPais() %></td>
                                    <td><%= f.getDataCadastro() %></td>
                                    <td class="col-acoes">
                                        <a class="btn btn-secundario btn-pequeno"
                                           href="<%= request.getContextPath() %>/buscar?nif=<%= f.getNif() %>&modo=ver">
                                            <span class="icone" aria-hidden="true">&#128065;</span>
                                            <span>Ver</span>
                                        </a>
                                        <a class="btn btn-secundario btn-pequeno"
                                           href="<%= request.getContextPath() %>/buscar?nif=<%= f.getNif() %>">
                                            <span class="icone" aria-hidden="true">&#9998;</span>
                                            <span>Alterar</span>
                                        </a>
                                        <form action="<%= request.getContextPath() %>/cadastro" method="post"
                                              data-loading="true"
                                              data-confirmar="Tem a certeza que quer eliminar o fornecedor '<%= f.getNome() %>'? Esta accao nao pode ser desfeita.">
                                            <input type="hidden" name="tipoOperacao" value="Eliminar">
                                            <input type="hidden" name="nif" value="<%= f.getNif() %>">
                                            <button type="submit" class="btn btn-perigo btn-pequeno">
                                                <span class="icone" aria-hidden="true">&#128465;</span>
                                                <span>Eliminar</span>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
<%
        }
%>
                            </tbody>
                        </table>
                    </div>
                    <p class="rodape-lista">Encontrado(s) <%= total %> fornecedor(es)</p>
<%
    }
%>

                    <a href="<%= request.getContextPath() %>/cadastro.jsp" class="voltar">&laquo; Voltar ao Cadastro</a>
                </div>

<%@ include file="includes/rodape.jspf" %>
