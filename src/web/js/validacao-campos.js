/* ============================================================
   FormZAP - Fase 2 | Validacao de campos dependentes do pais
   ============================================================
   
   IMPORTANTE - duplicacao deliberada e inevitavel:
   Este ficheiro e uma "copia" em JavaScript das mesmas regras que
   ja existem em Validacoes.java isso porque o browser nao pode
   chamar codigo Java directamente, por isso as mesmas regras tem
   de existir duas vezes (uma em Java, para proteger a base de
   dados a serio; uma aqui, so para dar feedback visual rapido ao
   utilizador). A validacao AQUI e cosmetica. A validacao que
   protege os dados de verdade e sempre a do Servlet + Validacoes
   .java. Se algum dia mudarem os regex do lado do Java, tem de se
   actualizar tambem aqui.

   O que este ficheiro faz:
     1) Guarda os regex e exemplos por pais (Angola / Mocambique /
        Portugal) para NIF, telefone e IBAN/SWIFT.
     2) Quando o utilizador muda o <select> de pais, actualiza o
        texto de exemplo por baixo do campo dependente.
     3) Ao sair do campo (evento "blur"), valida o valor contra o
        regex do pais actualmente seleccionado:
          - Valido   -> borda fica verde/azul (classe campo-valido)
          - Invalido -> borda fica vermelha (classe campo-invalido),
                        o valor do campo e APAGADO, e aparece uma
                        mensagem "Formato invalido" por baixo.
     3b) CORRECAO: website, email e numeroConta tambem tem formato
         proprio (ver Validacoes.java), mas nao dependem de nenhum
         pais - por isso tem a sua propria validacao no blur, em
         paralelo com a validacao por pais acima.
     4) No submit do formulario, confirma que todos os campos
        obrigatorios estao preenchidos; se nao estiverem, impede o
        envio, marca-os a vermelho e foca o primeiro em falta.
   ============================================================ */
(function () {
    "use strict";

    // ------------------------------------------------------------
    // 1) Regras por pais (espelho de Validacoes.java)
    // ------------------------------------------------------------
    var REGRAS_PAIS = {
        "Angola": {
            
            nif: { regex: /^5[0-9]{9}$/, exemplo: "Ex.: 5000614971" },
            telefone: { regex: /^(\+244)?9[0-9]{8}$/, exemplo: "Ex.: +244 923 456 789" },
            iban: { regex: /^AO06[0-9]{21}$/i, exemplo: "Ex.: AO06000600001011223344521" },
            swift: { regex: /^[A-Z]{4}AO[A-Z0-9]{2}([A-Z0-9]{3})?$/i, exemplo: "Ex.: BAIAAOLU" }
        },
        "Mocambique": {
            nif: { regex: /^[0-9]{9}$/, exemplo: "Ex.: 123456789" },
            telefone: { regex: /^(\+258)?[89][0-9]{8}$/, exemplo: "Ex.: +258 823 456 789" },
            iban: { regex: /^MZ59[0-9]{21}$/i, exemplo: "Ex.: MZ59000100002022334455621" },
            swift: { regex: /^[A-Z]{4}MZ[A-Z0-9]{2}([A-Z0-9]{3})?$/i, exemplo: "Ex.: BCIMMZMX" }
        },
        "Portugal": {
            nif: { regex: /^[0-9]{9}$/, exemplo: "Ex.: 123456789" },
            telefone: { regex: /^(\+351)?[29][0-9]{8}$/, exemplo: "Ex.: +351 912 345 678" },
            iban: { regex: /^PT50[0-9]{21}$/i, exemplo: "Ex.: PT50000201231234567890123" },
            swift: { regex: /^[A-Z]{4}PT[A-Z0-9]{2}([A-Z0-9]{3})?$/i, exemplo: "Ex.: CGDIPTPL" }
        }
    };

    // NIF aceite quando NAO ha selector de pais (pesquisar.jsp) -
    // aceita qualquer um dos 3 formatos.
    function nifValidoQualquerPais(valor) {
        return REGRAS_PAIS["Angola"].nif.regex.test(valor)
            || REGRAS_PAIS["Mocambique"].nif.regex.test(valor)
            || REGRAS_PAIS["Portugal"].nif.regex.test(valor);
    }

    document.addEventListener("DOMContentLoaded", function () {
        ligarSelectoresDePais();
        ligarValidacaoNoBlur();
        ligarValidacaoCamposSemPais();
        ligarValidacaoCamposObrigatoriosGenericos();
        ligarValidacaoDeData();
        ligarValidacaoObrigatoriosNoSubmit();
        ligarResetBotaoAoEditar();
        ligarBuscaNifSemPais();
    });

    // ------------------------------------------------------------
    // 2) Actualizar o texto de exemplo quando o pais muda
    // ------------------------------------------------------------
    function ligarSelectoresDePais() {
        // selectPais controla: nif, telefone, telefoneContacto
        var selectPais = document.getElementById("pais");
        if (selectPais) {
            selectPais.addEventListener("change", function () {
                atualizarExemplo(selectPais.value, "nif", "nifAjuda");
                atualizarExemplo(selectPais.value, "telefone", "telefoneAjuda");
                atualizarExemplo(selectPais.value, "telefone", "telefoneContactoAjuda");
                // revalida os campos ja preenchidos com as novas regras
                revalidarSeTiverValor("nif", selectPais.value, "nif");
                revalidarSeTiverValor("telefone", selectPais.value, "telefone");
                revalidarSeTiverValor("telefoneContacto", selectPais.value, "telefone");
            });
            // aplica os exemplos certos logo ao carregar a pagina
            if (selectPais.value) {
                atualizarExemplo(selectPais.value, "nif", "nifAjuda");
                atualizarExemplo(selectPais.value, "telefone", "telefoneAjuda");
                atualizarExemplo(selectPais.value, "telefone", "telefoneContactoAjuda");
            }
        }

        // selectPaisBanco controla: iban, swift
        var selectPaisBanco = document.getElementById("paisBanco");
        if (selectPaisBanco) {
            selectPaisBanco.addEventListener("change", function () {
                atualizarExemplo(selectPaisBanco.value, "iban", "ibanAjuda");
                atualizarExemplo(selectPaisBanco.value, "swift", "swiftAjuda");
                revalidarSeTiverValor("iban", selectPaisBanco.value, "iban");
                revalidarSeTiverValor("swift", selectPaisBanco.value, "swift");
            });
            if (selectPaisBanco.value) {
                atualizarExemplo(selectPaisBanco.value, "iban", "ibanAjuda");
                atualizarExemplo(selectPaisBanco.value, "swift", "swiftAjuda");
            }
        }
    }

    function atualizarExemplo(pais, tipoCampo, idElementoAjuda) {
        var elementoAjuda = document.getElementById(idElementoAjuda);
        if (!elementoAjuda) return;
        var regra = REGRAS_PAIS[pais];
        elementoAjuda.textContent = regra ? regra[tipoCampo].exemplo : "Seleccione o pais para ver um exemplo.";
    }

    function revalidarSeTiverValor(idCampo, pais, tipoCampo) {
        var campo = document.getElementById(idCampo);
        if (campo && campo.value) {
            validarCampoPorPais(campo, pais, tipoCampo);
        }
    }

    // ------------------------------------------------------------
    // 3) Validar no "blur" (quando o utilizador sai do campo)
    // ------------------------------------------------------------
    function ligarValidacaoNoBlur() {
        ligarCampo("nif", "pais", "nif");
        ligarCampo("telefone", "pais", "telefone");
        ligarCampo("telefoneContacto", "pais", "telefone");
        ligarCampo("iban", "paisBanco", "iban");
        ligarCampo("swift", "paisBanco", "swift");
    }

    function ligarCampo(idCampo, idSelectPais, tipoCampo) {
        var campo = document.getElementById(idCampo);
        var selectPais = document.getElementById(idSelectPais);
        if (!campo) return;

        campo.addEventListener("blur", function () {
            var pais = selectPais ? selectPais.value : "";
            validarCampoPorPais(campo, pais, tipoCampo);
        });
    }

    /**
     * Valida um campo contra o regex do pais indicado. Se invalido:
     * marca a vermelho, APAGA o valor do campo, e mostra mensagem.
     * Se valido: marca a verde/azul e limpa a mensagem de erro.
     * Campos vazios (e opcionais, como SWIFT) nao sao marcados.
     */
    function validarCampoPorPais(campo, pais, tipoCampo) {
        var valor = campo.value.trim();
        var idAjuda = campo.id + "Ajuda";
        var elementoAjuda = document.getElementById(idAjuda);
        var campoOpcional = (tipoCampo === "swift"); // SWIFT e opcional

        if (valor === "") {
            if (campoOpcional) {
                limparEstadoCampo(campo);
            }
            return; // campos obrigatorios vazios sao tratados no submit
        }

        if (!pais || !REGRAS_PAIS[pais]) {
            // sem pais seleccionado ainda nao da para validar o formato
            return;
        }

        var regra = REGRAS_PAIS[pais][tipoCampo];
        var valido = regra.regex.test(valor);

        if (valido) {
            marcarCampoValido(campo);
            if (elementoAjuda) {
                elementoAjuda.textContent = regra.exemplo;
                elementoAjuda.classList.remove("ajuda-erro");
            }
        } else {
            marcarCampoInvalido(campo);
            campo.value = ""; // apaga automaticamente o valor mal preenchido
            if (elementoAjuda) {
                elementoAjuda.textContent = "Formato invalido. " + regra.exemplo;
                elementoAjuda.classList.add("ajuda-erro");
            }
            campo.focus();
        }
    }

    function marcarCampoValido(campo) {
        campo.classList.remove("campo-invalido");
        campo.classList.add("campo-valido");
        campo.setAttribute("aria-invalid", "false");
    }

    function marcarCampoInvalido(campo) {
        campo.classList.remove("campo-valido");
        campo.classList.add("campo-invalido");
        campo.setAttribute("aria-invalid", "true");
    }

    function limparEstadoCampo(campo) {
        campo.classList.remove("campo-valido", "campo-invalido");
        campo.removeAttribute("aria-invalid");
    }

    // ------------------------------------------------------------
    // 3b) Campos com formato proprio mas SEM pais associado:
    //     website, email, numeroConta. Estes tinham regex definidos
    //     em Validacoes.java mas nunca estavam ligados a nenhum
    //     evento aqui no browser - corrigido agora.
    // ------------------------------------------------------------
    var REGRAS_SEM_PAIS = {
        website: {
            regex: /^(https?:\/\/)?([\w-]+\.)+[a-zA-Z]{2,}(\/.*)?$/,
            obrigatorio: false,
            mensagemErro: "Website invalido. Ex.: https://www.exemplo.com"
        },
        email: {
            regex: /^[\w.+-]+@([\w-]+\.)+[a-zA-Z]{2,}$/,
            obrigatorio: true,
            mensagemErro: "Email invalido. Ex.: nome@empresa.com"
        },
        numeroConta: {
            regex: /^[0-9]{6,20}$/,
            obrigatorio: false,
            mensagemErro: "Numero de conta invalido. Deve conter apenas digitos (6 a 20)."
        }
    };

    function ligarValidacaoCamposSemPais() {
        Object.keys(REGRAS_SEM_PAIS).forEach(function (idCampo) {
            // ha 2 campos de email na pagina (email do fornecedor e,
            // no futuro, outros); aqui tratamos apenas o principal.
            var campo = document.getElementById(idCampo);
            if (!campo) return;

            campo.addEventListener("blur", function () {
                validarCampoSemPais(campo, REGRAS_SEM_PAIS[idCampo]);
            });
        });
    }

    function validarCampoSemPais(campo, regra) {
        var valor = campo.value.trim();
        var idAjuda = campo.id + "Ajuda";
        var elementoAjuda = document.getElementById(idAjuda);

        if (valor === "") {
            // campo vazio: se for opcional, nao marca nada; se for
            // obrigatorio, o aviso aparece no submit (ver secao 6),
            // nao aqui no blur (para nao assustar quem ainda nem
            // chegou a escrever nada no campo).
            limparEstadoCampo(campo);
            return;
        }

        var valido = regra.regex.test(valor);

        if (valido) {
            marcarCampoValido(campo);
            if (elementoAjuda) {
                elementoAjuda.classList.remove("ajuda-erro");
            }
        } else {
            marcarCampoInvalido(campo);
            campo.value = "";
            if (elementoAjuda) {
                elementoAjuda.textContent = regra.mensagemErro;
                elementoAjuda.classList.add("ajuda-erro");
            }
            campo.focus();
        }
    }

    // ------------------------------------------------------------
    // 4) Busca por NIF em pesquisar.jsp - sem selector de pais,
    //    aceita qualquer um dos 3 formatos.
    // ------------------------------------------------------------
    function ligarBuscaNifSemPais() {
        var campoBusca = document.getElementById("buscaNif");
        if (!campoBusca) return;

        campoBusca.addEventListener("blur", function () {
            var valor = campoBusca.value.trim();
            if (valor === "") return;

            if (nifValidoQualquerPais(valor)) {
                marcarCampoValido(campoBusca);
            } else {
                marcarCampoInvalido(campoBusca);
                campoBusca.value = "";
                var ajuda = document.getElementById("buscaNifAjuda");
                if (ajuda) {
                    ajuda.textContent = "NIF invalido. Formatos aceites: Angola (ex.: 5000614971), Mocambique ou Portugal (ex.: 123456789).";
                    ajuda.classList.add("ajuda-erro");
                }
                campoBusca.focus();
            }
        });
    }

    // ------------------------------------------------------------
    // 5) Data: nao pode estar mal preenchida nem no passado
    // ------------------------------------------------------------
    function ligarValidacaoDeData() {
        var camposData = document.querySelectorAll("input[type='date'][data-nao-permite-passado]");
        camposData.forEach(function (campo) {
            campo.addEventListener("blur", function () {
                var valor = campo.value; // input[type=date] ja da yyyy-MM-dd
                if (!valor) return;

                var hoje = new Date();
                hoje.setHours(0, 0, 0, 0);
                var dataEscolhida = new Date(valor + "T00:00:00");

                if (isNaN(dataEscolhida.getTime()) || dataEscolhida < hoje) {
                    marcarCampoInvalido(campo);
                    campo.value = "";
                    var idAjuda = campo.id + "Ajuda";
                    var ajuda = document.getElementById(idAjuda);
                    if (ajuda) {
                        ajuda.textContent = "Data invalida. Escolha hoje ou uma data futura.";
                        ajuda.classList.add("ajuda-erro");
                    }
                    campo.focus();
                } else {
                    marcarCampoValido(campo);
                }
            });
        });
    }

    // ------------------------------------------------------------
    // 5a-bis) Campos obrigatorios SEM regra de formato propria
    //     (ex.: nome, morada, pais, provinciaDistrito,
    //     municipioConcelho, ramoActividade, paisBanco, banco,
    //     nomeContacto) - texto livre, a unica regra e "nao pode
    //     estar vazio".
    //
    //     Os campos que JA TEM validacao de formato propria (nif,
    //     telefone, telefoneContacto, iban, swift, website, email,
    //     numeroConta) sao ignorados aqui de proposito, para nao
    //     interferir com a logica mais rigorosa deles.
    // ------------------------------------------------------------
    function ligarValidacaoCamposObrigatoriosGenericos() {
        var idsComValidacaoPropria = [
            "nif", "telefone", "telefoneContacto", "iban", "swift",
            "website", "email", "numeroConta"
        ];

        var camposObrigatorios = document.querySelectorAll("[required]");
        camposObrigatorios.forEach(function (campo) {
            if (idsComValidacaoPropria.indexOf(campo.id) !== -1) {
                return; // ja tratado nas seccoes 3/3b
            }

            function reavaliar() {
                if (campo.value.trim() !== "") {
                    marcarCampoValido(campo);
                } else {
                    // volta a neutro; o vermelho so reaparece se o
                    // utilizador tentar submeter outra vez vazio
                    limparEstadoCampo(campo);
                }
            }

            campo.addEventListener("input", reavaliar);
            campo.addEventListener("change", reavaliar);
        });
    }

    // ------------------------------------------------------------
    // 5b) Reset directo do botao "Salvar/Guardar" sempre que o
    //     utilizador edita QUALQUER campo do formulario.
    //
    // ------------------------------------------------------------
    function ligarResetBotaoAoEditar() {
        var formularios = document.querySelectorAll("form[data-loading='true']");
        formularios.forEach(function (form) {
            function repor() {
                var botaoSubmeter = form.querySelector("button[type='submit']");
                if (botaoSubmeter) {
                    botaoSubmeter.classList.remove("is-loading");
                    botaoSubmeter.removeAttribute("aria-busy");
                    botaoSubmeter.disabled = false;
                }
            }
            form.addEventListener("input", repor);
            form.addEventListener("change", repor);
        });
    }


    // ------------------------------------------------------------
    function ligarValidacaoObrigatoriosNoSubmit() {
        var formularios = document.querySelectorAll("form[data-loading='true']");
        formularios.forEach(function (form) {
            form.addEventListener("submit", function (evento) {
                var camposObrigatorios = form.querySelectorAll("[required]:not(:disabled)");
                var primeiroInvalido = null;

                camposObrigatorios.forEach(function (campo) {
                    if (campo.value.trim() === "") {
                        marcarCampoInvalido(campo);
                        if (!primeiroInvalido) primeiroInvalido = campo;
                    } else {
                        // nao mexe num campo que ja esteja marcado como
                        // invalido/valido por outra validacao (ex.: NIF)
                        if (!campo.classList.contains("campo-invalido")) {
                            marcarCampoValido(campo);
                        }
                    }
                });

                if (primeiroInvalido) {
                    evento.preventDefault();
                    // ajuda quando a ordem dos scripts calha a ser favoravel
                    if (evento.stopImmediatePropagation) {
                        evento.stopImmediatePropagation();
                    }

                    // GARANTE que o botao fica sempre correcto, seja qual
                    // for a ordem dos scripts (ver explicacao acima)
                    var botaoSubmeter = form.querySelector("button[type='submit']");
                    if (botaoSubmeter) {
                        setTimeout(function () {
                            botaoSubmeter.classList.remove("is-loading");
                            botaoSubmeter.removeAttribute("aria-busy");
                            botaoSubmeter.disabled = false;
                        }, 0);
                    }

                    // blindado com try/catch: focus()/scrollIntoView() sao so
                    // conforto visual - um erro aqui NUNCA deve impedir a
                    // reposicao do botao feita acima
                    try {
                        primeiroInvalido.focus();
                        if (typeof primeiroInvalido.scrollIntoView === "function") {
                            primeiroInvalido.scrollIntoView({ behavior: "smooth", block: "center" });
                        }
                    } catch (erro) {
                        // silencioso de proposito - nao interessa ao utilizador
                    }

                    if (window.formZapToast) {
                        window.formZapToast("Preencha todos os campos obrigatorios antes de submeter.", "erro");
                    }
                }
                
            });
        });
    }
})();


