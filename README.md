# 📋 FormZAP — Aplicação Web de Cadastro de Fornecedores

**Projeto académico em equipa — Sistemas Distribuídos e Paralelos I**
**Universidade Católica de Angola, Faculdade de Engenharia — Luanda, 2026**

> ⚠️ Este repositório documenta especificamente a **camada de Visão (View)**, da autoria de Íris João. O FormZAP foi desenvolvido por uma equipa de 5 pessoas, cada uma responsável por uma camada da arquitetura — as restantes camadas (Controlador, Modelo, DAO, Base de Dados) foram implementadas pelos colegas de equipa.

Aplicação web transacional para gestão do ciclo de vida completo dos fornecedores da ZAP, com operações CRUD completas (Criar, Listar, Alterar, Eliminar). O projeto representa a evolução de um sistema desktop anterior (JavaFX + ficheiro binário) para uma solução web centralizada, seguindo a arquitetura de três camadas (Visão–Controlador–Modelo).

## 👥 Equipa e responsabilidades

| Nome | Camada | Responsabilidade |
|---|---|---|
| Janete Francisco | Dados (PostgreSQL) | Criação e testes da base de dados |
| **Íris João** | **Visão** | **Desenvolvimento das interfaces (JSP/HTML/CSS)** |
| Jonilson Nhanga | Controlador | Servlets e lógica de controlo |
| Elizabeth Ndele | Modelo | JavaBean e validações |
| Marlene Francisco | Persistência | DAO e acesso a dados |

## 🎨 A minha contribuição — Camada de Visão (JSP)

Responsável pelo desenvolvimento de toda a interface do utilizador, construída em JSP, HTML e CSS, incluindo:

- **`cadastro.jsp`** — formulário de criação, com 23 campos organizados em três secções e pré-preenchimento automático quando vindo de uma pesquisa
- **`pesquisar.jsp`** — página dedicada à busca de fornecedores por NIF, para as operações de Alterar e Eliminar
- **`listagem.jsp`** — tabela com todos os fornecedores cadastrados, com ações de Ver, Alterar e Eliminar por linha
- **`inicio.jsp`** — painel inicial com atalhos para as três operações principais
- Fragmentos JSP reutilizáveis (`cabecalho.jspf`, `rodape.jspf`) partilhados por todas as páginas
- Confirmação de eliminação via caixa de diálogo JavaScript
- Navegação lateral consistente em todas as páginas, com indicação da página atual
- Integração com validações no cliente (`validacao-campos.js`), com feedback visual (bordas verdes/vermelhas) e bloqueio de submissão em caso de campos inválidos

## 🏗️ Arquitetura geral do sistema

O projeto segue o padrão de arquitetura de três camadas:

- **Visão (JSP/HTML)** — apresentação e captura de dados do utilizador *(esta camada)*
- **Controlador (Servlets)** — processa pedidos e orquestra a lógica de navegação
- **Modelo (JavaBean + Validações)** — regras de negócio e validação de dados
- **Persistência (DAO)** — acesso à base de dados via JDBC com `PreparedStatement`

## 🛠️ Tecnologias utilizadas no projeto

- Java 17 (JDK), Jakarta EE 10
- Servlets (Jakarta Servlet 6.0), JSP (Jakarta Server Pages 3.1)
- JDBC 4.3, PostgreSQL
- Apache Tomcat 10.1.x
- Maven, NetBeans 25
- HTML5 / CSS3 / JavaScript

## ✅ Resultados

O sistema foi validado com 21 testes de integração contra PostgreSQL real (100% de aprovação) e 79 testes automatizados às camadas de validação, cobrindo todos os fluxos de CRUD.

## 👩‍💻 Autoria

Camada de Visão desenvolvida por **Íris João**, no âmbito da disciplina de Sistemas Distribuídos e Paralelos I.
