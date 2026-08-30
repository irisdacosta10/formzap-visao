/* ============================================================
   FormZAP - Fase 2 | Pessoa 2 (Iris) - Visao
   Comportamento partilhado por todas as paginas:
     - sidebar colapsavel (desktop) e off-canvas (mobile)
     - toasts de feedback (sucesso/erro/aviso)
     - estado de "loading" nos botoes ao submeter formularios
     - mostrar/ocultar seccoes do formulario consoante a operacao
     - confirmacao antes de eliminar
     - abrir/fechar o painel de edicao no cartao do fornecedor
       (pesquisar.jsp)
   ============================================================ */
(function () {
    "use strict";

    document.addEventListener("DOMContentLoaded", function () {
        iniciarSidebar();
        iniciarLoadingEmFormularios();
        iniciarOperacaoCondicional();
        iniciarConfirmacaoEliminar();
        iniciarPainelEdicao();
        mostrarToastsIniciais();
    });

    /* ---------------- Sidebar ---------------- */
    function iniciarSidebar() {
        var shell = document.querySelector(".app-shell");
        if (!shell) return;

        var btnColapsar = document.getElementById("btnColapsarSidebar");
        var btnMobile = document.getElementById("btnAbrirSidebarMobile");
        var overlay = document.querySelector(".sidebar-overlay");

        var colapsada = window.localStorage.getItem("formzap:sidebarColapsada") === "1";
        if (colapsada) shell.classList.add("sidebar-colapsada");
        atualizarAriaColapsar();

        if (btnColapsar) {
            btnColapsar.addEventListener("click", function () {
                shell.classList.toggle("sidebar-colapsada");
                var estaColapsada = shell.classList.contains("sidebar-colapsada");
                window.localStorage.setItem("formzap:sidebarColapsada", estaColapsada ? "1" : "0");
                atualizarAriaColapsar();
            });
        }

        if (btnMobile) {
            btnMobile.addEventListener("click", function () {
                shell.classList.toggle("sidebar-mobile-aberta");
                var aberta = shell.classList.contains("sidebar-mobile-aberta");
                btnMobile.setAttribute("aria-expanded", aberta ? "true" : "false");
            });
        }

        if (overlay) {
            overlay.addEventListener("click", function () {
                shell.classList.remove("sidebar-mobile-aberta");
                if (btnMobile) btnMobile.setAttribute("aria-expanded", "false");
            });
        }

        function atualizarAriaColapsar() {
            if (!btnColapsar) return;
            var estaColapsada = shell.classList.contains("sidebar-colapsada");
            btnColapsar.setAttribute("aria-expanded", estaColapsada ? "false" : "true");
        }
    }

    /* ---------------- Loading state nos botoes de submeter ---------------- */
    function iniciarLoadingEmFormularios() {
        var forms = document.querySelectorAll("form[data-loading='true']");
        forms.forEach(function (form) {
            form.addEventListener("submit", function (evento) {
                if (form.hasAttribute("data-confirmar") && !form.dataset.confirmado) {
                    return; // a confirmacao trata do reenvio
                }
                var botao = form.querySelector("button[type='submit']");
                if (botao && !botao.classList.contains("is-loading")) {
                    botao.classList.add("is-loading");
                    botao.setAttribute("aria-busy", "true");
                    botao.disabled = true;
                }
            });
        });
    }

    /* ---------------- Mostrar/ocultar seccoes conforme a operacao ---------------- */
    function iniciarOperacaoCondicional() {
        var radios = document.querySelectorAll("input[name='tipoOperacao']");
        if (!radios.length) return;

        var seccoesCompletas = document.querySelectorAll("[data-seccao-completa]");
        var camposObrigatoriosBase = document.querySelectorAll("[data-obrigatorio-base]");

        function aplicar() {
            var selecionado = document.querySelector("input[name='tipoOperacao']:checked");
            var operacao = selecionado ? selecionado.value : "Criar";
            var eEliminar = operacao === "Eliminar";

            seccoesCompletas.forEach(function (seccao) {
                seccao.setAttribute("data-desactivada", eEliminar ? "true" : "false");
                var campos = seccao.querySelectorAll("input, select, textarea");
                campos.forEach(function (campo) {
                    campo.disabled = eEliminar;
                });
            });

            camposObrigatoriosBase.forEach(function (campo) {
                campo.required = !eEliminar;
            });

            var avisoEliminar = document.getElementById("avisoEliminar");
            if (avisoEliminar) {
                avisoEliminar.hidden = !eEliminar;
            }

            var textoBotaoSalvar = document.getElementById("textoBotaoSalvar");
            if (textoBotaoSalvar) {
                var textos = { Criar: "Salvar Cadastro", Alterar: "Guardar Alteracoes", Eliminar: "Eliminar Fornecedor" };
                textoBotaoSalvar.textContent = textos[operacao] || "Salvar";
            }

            var botaoSalvar = document.getElementById("botaoSalvar");
            if (botaoSalvar) {
                botaoSalvar.classList.toggle("btn-perigo", eEliminar);
                botaoSalvar.classList.toggle("btn-primario", !eEliminar);
            }
        }

        radios.forEach(function (radio) {
            radio.addEventListener("change", aplicar);
        });
        aplicar();
    }

    /* ---------------- Painel de edicao (cartao do fornecedor, pesquisar.jsp) ---------------- */
    function iniciarPainelEdicao() {
        var botao = document.getElementById("btnEditarFornecedor");
        var painel = document.getElementById("painelEdicaoFornecedor");
        if (!botao || !painel) return;

        botao.addEventListener("click", function () {
            var estaAberto = !painel.hidden;
            painel.hidden = estaAberto;
            botao.setAttribute("aria-expanded", estaAberto ? "false" : "true");

            if (!estaAberto) {
                var primeiroCampo = painel.querySelector("input, select, textarea");
                if (primeiroCampo) primeiroCampo.focus();
                painel.scrollIntoView({ behavior: "smooth", block: "start" });
            }
        });
    }

    /* ---------------- Confirmacao antes de eliminar ---------------- */
    function iniciarConfirmacaoEliminar() {
        var formularios = document.querySelectorAll("form[data-confirmar]");
        formularios.forEach(function (form) {
            form.addEventListener("submit", function (evento) {
                if (form.dataset.confirmado) return;
                evento.preventDefault();
                var mensagem = form.getAttribute("data-confirmar") || "Tem a certeza?";
                if (window.confirm(mensagem)) {
                    form.dataset.confirmado = "1";
                    var botao = form.querySelector("button[type='submit']");
                    if (botao) {
                        botao.classList.add("is-loading");
                        botao.setAttribute("aria-busy", "true");
                        botao.disabled = true;
                    }
                    form.submit();
                }
            });
        });
    }

    /* ---------------- Toasts ---------------- */
    function criarToastContainer() {
        var container = document.getElementById("toast-container");
        if (!container) {
            container = document.createElement("div");
            container.id = "toast-container";
            container.setAttribute("aria-live", "polite");
            container.setAttribute("aria-atomic", "true");
            document.body.appendChild(container);
        }
        return container;
    }

    function mostrarToast(mensagem, tipo) {
        tipo = tipo || "sucesso";
        var container = criarToastContainer();
        var toast = document.createElement("div");
        toast.className = "toast toast--" + tipo;
        toast.setAttribute("role", tipo === "erro" ? "alert" : "status");

        var icones = { sucesso: "\u2713", erro: "\u26A0", aviso: "\u24D8" };
        toast.innerHTML =
            '<span class="icone" aria-hidden="true">' + (icones[tipo] || "") + "</span>" +
            '<span class="toast__texto"></span>' +
            '<button type="button" class="toast__fechar" aria-label="Fechar notificacao">&times;</button>';
        toast.querySelector(".toast__texto").textContent = mensagem;

        toast.querySelector(".toast__fechar").addEventListener("click", function () {
            toast.remove();
        });

        container.appendChild(toast);
        window.setTimeout(function () {
            if (toast.parentNode) toast.remove();
        }, 6000);
    }

    // Exposto globalmente para as JSPs poderem chamar via pequenos scripts inline
    window.formZapToast = mostrarToast;

    function mostrarToastsIniciais() {
        var origem = document.getElementById("dados-toast-inicial");
        if (!origem) return;
        var mensagem = origem.getAttribute("data-mensagem");
        var tipo = origem.getAttribute("data-tipo") || "sucesso";
        if (mensagem) {
            mostrarToast(mensagem, tipo);
        }
    }
})();
