<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    ============================================================
    FormZAP - Fase 2 | Pessoa 2 (Iris) - VISAO
    Ficheiro: inicio.jsp

    Pagina inicial (dashboard) da aplicacao. Serve para:
      1) Dar um ponto de entrada mais "cheio" e profissional do que
         cair directamente no formulario de Criar.
      2) Tornar visiveis, como ATALHOS, os tres destinos que fazem
         sentido sem um fornecedor especifico ja seleccionado:
         Novo Fornecedor, Pesquisar/Alterar e Lista de Fornecedores.

    Nota de UX (decisao deliberada): "Eliminar" nao tem aqui um
    atalho proprio porque e uma accao que exige um alvo concreto
    (um fornecedor ja identificado) - por isso so aparece junto de
    cada linha na Lista de Fornecedores, nunca como destino "as
    cegas" no menu ou nesta pagina.
    ============================================================
--%>
<%
    String paginaAtual = "inicio";
    String tituloPagina = "Inicio";
    String subtituloPagina = "Painel de gestao de fornecedores ZAP";
    String toastMensagem = null;
    String toastTipo = null;
%>
<%@ include file="includes/cabecalho.jspf" %>

                <div class="folha">
                    <div class="painel-boas-vindas">
                        <div class="painel-boas-vindas__texto">
                            <p class="painel-boas-vindas__saudacao">Bem-vindo(a) de volta</p>
                            <h2 class="painel-boas-vindas__titulo">Gestao de Fornecedores ZAP</h2>
                            <p class="painel-boas-vindas__descricao">
                                Cria novos registos, pesquisa e altera fornecedores existentes pelo NIF,
                                ou consulta a lista completa - tudo num so lugar.
                            </p>
                        </div>
                        <svg class="painel-boas-vindas__ilustracao" viewBox="0 0 220 160" role="img"
                             aria-label="Ilustracao decorativa de documentos e rede de fornecedores">
                            <circle cx="110" cy="80" r="70" fill="var(--cor-primaria-suave)"></circle>
                            <rect x="55" y="45" width="70" height="90" rx="8" fill="#ffffff" stroke="var(--cor-primaria)" stroke-width="3"></rect>
                            <line x1="68" y1="65" x2="112" y2="65" stroke="var(--cor-primaria)" stroke-width="4" stroke-linecap="round"></line>
                            <line x1="68" y1="80" x2="112" y2="80" stroke="var(--cor-borda)" stroke-width="4" stroke-linecap="round"></line>
                            <line x1="68" y1="95" x2="100" y2="95" stroke="var(--cor-borda)" stroke-width="4" stroke-linecap="round"></line>
                            <line x1="68" y1="110" x2="106" y2="110" stroke="var(--cor-borda)" stroke-width="4" stroke-linecap="round"></line>
                            <circle cx="150" cy="55" r="22" fill="#ffffff" stroke="var(--cor-acento)" stroke-width="3"></circle>
                            <path d="M141 55 l6 6 12 -13" fill="none" stroke="var(--cor-acento-escuro)" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"></path>
                            <circle cx="45" cy="115" r="14" fill="#ffffff" stroke="var(--cor-primaria)" stroke-width="3"></circle>
                            <text x="45" y="120" text-anchor="middle" font-size="14" font-weight="bold" fill="var(--cor-primaria)">%</text>
                        </svg>
                    </div>

                    <h2 class="titulo-seccao-cards">O que pretende fazer?</h2>
                    <div class="grelha-cards">
                        <a class="card-atalho" href="<%= request.getContextPath() %>/cadastro.jsp">
                            <span class="card-atalho__icone" aria-hidden="true">&#10133;</span>
                            <span class="card-atalho__titulo">Novo Fornecedor</span>
                            <span class="card-atalho__descricao">Criar um registo do zero, com todos os dados gerais, bancarios e de contacto.</span>
                        </a>

                        <a class="card-atalho" href="<%= request.getContextPath() %>/pesquisar.jsp">
                            <span class="card-atalho__icone" aria-hidden="true">&#128269;</span>
                            <span class="card-atalho__titulo">Pesquisar / Alterar</span>
                            <span class="card-atalho__descricao">Procurar um fornecedor pelo NIF e actualizar os dados existentes.</span>
                        </a>

                        <a class="card-atalho" href="<%= request.getContextPath() %>/listar">
                            <span class="card-atalho__icone" aria-hidden="true">&#128203;</span>
                            <span class="card-atalho__titulo">Lista de Fornecedores</span>
                            <span class="card-atalho__descricao">Ver todos os fornecedores cadastrados e eliminar registos, um a um.</span>
                        </a>
                    </div>

                    <p class="nota-seccao" style="margin-top:22px;">
                        Nota: "Eliminar" so aparece junto de cada fornecedor na Lista, porque e uma accao
                        que precisa sempre de um registo especifico ja identificado.
                    </p>
                </div>

<%@ include file="includes/rodape.jspf" %>
