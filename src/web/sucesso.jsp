<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Fornecedor" %>
<%--
    ============================================================
    FormZAP - Fase 2 | Pessoa 2 (Iris) - VISAO
    Ficheiro: sucesso.jsp

    O Servlet (Pessoa 3), depois de guardar/alterar/eliminar com
    sucesso, deve fazer algo como:
        request.setAttribute("fornecedor", f);
        request.setAttribute("mensagemSucesso", "Cadastro guardado com sucesso!");
        request.getRequestDispatcher("sucesso.jsp").forward(request, response);

    Se "fornecedor" nao vier definido (por exemplo, apos um
    Eliminar, onde ja nao faz sentido mostrar dados), a pagina
    apenas mostra a mensagem de sucesso, sem o resumo.
    ============================================================
--%>
<%
    Fornecedor f = (Fornecedor) request.getAttribute("fornecedor");
    Object mensagemSucessoAttr = request.getAttribute("mensagemSucesso");
    String mensagemSucesso = (mensagemSucessoAttr != null)
            ? mensagemSucessoAttr.toString()
            : "Operacao concluida com sucesso!";

    // Nao fica marcada nenhuma opcao do menu: esta pagina e um
    // resultado (pode vir de Criar, Alterar ou Eliminar), nao faz
    // sentido acender sempre "Novo Fornecedor" como acontecia antes.
    String paginaAtual = "";
    String tituloPagina = "Operacao concluida";
    String subtituloPagina = null;
    String toastMensagem = mensagemSucesso;
    String toastTipo = "sucesso";
%>
<%@ include file="includes/cabecalho.jspf" %>

                <div class="folha folha--estreita">
                    <div class="cabecalho-cartao">
                        <img src="<%= request.getContextPath() %>/images/ZAP2.png" alt="ZAP">
                        <div>
                            <p class="titulo-form">Operacao concluida</p>
                        </div>
                    </div>

                    <div class="mensagem mensagem-sucesso" role="status">
                        <span class="icone" aria-hidden="true">&#10003;</span>
                        <strong><%= mensagemSucesso %></strong>
                    </div>

<%
    if (f != null) {
%>
                    <fieldset class="seccao-form">
                        <legend>Resumo do Fornecedor</legend>
                        <div class="grid">
                            <div class="campo">
                                <label for="resNome">Designacao Social</label>
                                <input type="text" id="resNome" value="<%= f.getNome() %>" readonly>
                            </div>
                            <div class="campo">
                                <label for="resNif">NIF</label>
                                <input type="text" id="resNif" value="<%= f.getNif() %>" readonly>
                            </div>
                            <div class="campo">
                                <label for="resTelefone">Telefone</label>
                                <input type="text" id="resTelefone" value="<%= f.getTelefone() %>" readonly>
                            </div>
                            <div class="campo">
                                <label for="resEmail">E-mail</label>
                                <input type="text" id="resEmail" value="<%= f.getEmail() %>" readonly>
                            </div>
                            <div class="campo largo">
                                <label for="resMorada">Morada</label>
                                <input type="text" id="resMorada" value="<%= f.getMorada() %>" readonly>
                            </div>
                            <div class="campo">
                                <label for="resPais">Pais</label>
                                <input type="text" id="resPais" value="<%= f.getPais() %>" readonly>
                            </div>
                            <div class="campo">
                                <label for="resBanco">Banco</label>
                                <input type="text" id="resBanco" value="<%= f.getBanco() %>" readonly>
                            </div>
                            <div class="campo">
                                <label for="resIban">IBAN</label>
                                <input type="text" id="resIban" value="<%= f.getIban() %>" readonly>
                            </div>
                            <div class="campo">
                                <label for="resWebsite">Website</label>
                                <input type="text" id="resWebsite" value="<%= f.getWebsite() %>" readonly>
                            </div>
                            <div class="campo">
                                <label for="resData">Data de Cadastro</label>
                                <input type="text" id="resData" value="<%= f.getDataCadastro() %>" readonly>
                            </div>
                        </div>
                    </fieldset>
<%
    }
%>
                    <div class="acoes" style="justify-content:flex-start;">
                        <a href="<%= request.getContextPath() %>/cadastro.jsp" class="btn btn-primario">
                            <span class="icone" aria-hidden="true">&#10133;</span>
                            <span>Cadastrar outro fornecedor</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/pesquisar.jsp" class="btn btn-secundario">
                            <span class="icone" aria-hidden="true">&#128269;</span>
                            <span>Pesquisar / Alterar outro</span>
                        </a>
                        <a href="<%= request.getContextPath() %>/listar" class="btn btn-secundario">
                            <span class="icone" aria-hidden="true">&#128203;</span>
                            <span>Ver lista de fornecedores</span>
                        </a>
                    </div>
                </div>

<%@ include file="includes/rodape.jspf" %>
