<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%--
    ============================================================
    FormZAP - Fase 2 | Pessoa 2 (Iris) - VISAO
    Ficheiro: erro.jsp

    Pagina de erro generica. Para ser usada, mapear no web.xml
    (fora do escopo da Visao), por exemplo:

        <error-page><error-code>404</error-code><location>/erro.jsp</location></error-page>
        <error-page><error-code>500</error-code><location>/erro.jsp</location></error-page>
        <error-page><exception-type>java.lang.Throwable</exception-type><location>/erro.jsp</location></error-page>
    ============================================================
--%>
<%
    String paginaAtual = "";
    String tituloPagina = "Ocorreu um erro";
    String subtituloPagina = null;
    String toastMensagem = null;
    String toastTipo = null;
%>
<%@ include file="includes/cabecalho.jspf" %>

                <div class="folha folha--estreita">
                    <div class="cabecalho-cartao">
                        <img src="<%= request.getContextPath() %>/images/ZAP2.png" alt="ZAP">
                        <div>
                            <p class="titulo-form">Cadastro de Fornecedor</p>
                        </div>
                    </div>

                    <div class="mensagem mensagem-erro" role="alert">
                        <span class="icone" aria-hidden="true">&#9888;</span>
                        <div>
                            <strong>Ops! Ocorreu um erro<%= (pageContext.getErrorData() != null) ? " " + pageContext.getErrorData().getStatusCode() : "" %>...</strong>
                            <p style="margin:6px 0 0;">
<%
    if (exception != null) {
%>
                                Erro interno no servidor: <%= exception.getMessage() %>
<%
    } else {
%>
                                A pagina procurada nao existe ou nao pode ser apresentada.
<%
    }
%>
                            </p>
                        </div>
                    </div>

                    <a href="<%= request.getContextPath() %>/cadastro.jsp" class="btn btn-primario">
                        <span class="icone" aria-hidden="true">&#8592;</span>
                        <span>Voltar ao Cadastro</span>
                    </a>
                </div>

<%@ include file="includes/rodape.jspf" %>
