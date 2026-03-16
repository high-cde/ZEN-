#!/bin/bash

echo "=== ZEN ULTRA AUTOBUILD — TERMINALE + CLI + SITE + COMMIT ==="

###############################################
# 1) CREAZIONE TERMINALE ZEN REALE (JS)
###############################################

echo "[TERMINAL] Aggiornamento terminale ZEN..."

mkdir -p docs

cat > docs/terminal.js << 'EOF'
// ZEN CLI + Terminal Engine — Browser Edition

function zen_exec(code) {
    const tokens = code.trim().split(/\s+/);
    const stack = [];

    for (let t of tokens) {
        if (!isNaN(t)) {
            stack.push(parseInt(t));
        } else if (t === "+") {
            stack.push(stack.pop() + stack.pop());
        } else if (t === "-") {
            let b = stack.pop(), a = stack.pop();
            stack.push(a - b);
        } else if (t === "*") {
            stack.push(stack.pop() * stack.pop());
        } else if (t === "/") {
            let b = stack.pop(), a = stack.pop();
            stack.push(a / b);
        } else if (t === "print") {
            return stack.pop();
        } else if (t === "help") {
            return "Comandi disponibili: + - * / print help info modules";
        } else if (t === "info") {
            return "ZEN Framework v1.0 — CLI Browser Edition";
        } else if (t === "modules") {
            return "[zvm, zasm, znet, zsec, zboot, zai, zdb, zfs, zui, zos, zos_services]";
        } else {
            return "Errore: comando sconosciuto '" + t + "'";
        }
    }
    return "(ok)";
}

function zen_terminal_init() {
    const term = document.getElementById("zen-terminal");
    const input = document.getElementById("zen-input");

    input.addEventListener("keydown", e => {
        if (e.key === "Enter") {
            const cmd = input.value;
            input.value = "";

            const result = zen_exec(cmd);
            term.textContent += "\n$ " + cmd + "\n" + result;
            term.scrollTop = term.scrollHeight;
        }
    });
}
EOF

###############################################
# 2) AGGIORNAMENTO INDEX CON TERMINALE REALE
###############################################

echo "[SITE] Aggiornamento index.html..."

cat > docs/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>ZEN Framework</title>
<link rel="stylesheet" href="style.css">
<style>
.hero { padding:80px 20px; text-align:center; background:#111; }
.section-title { font-size:2rem; text-align:center; margin-bottom:20px; }
.terminal { background:#000; color:#0f0; padding:20px; border-radius:10px;
            font-family:monospace; border:1px solid #0f0; max-width:900px; margin:auto; white-space:pre-wrap; }
</style>
</head>

<body>

<header>
    <h1>ZEN Framework</h1>
    <nav>
        <a href="index.html">Home</a>
        <a href="modules.html">Moduli</a>
        <a href="os.html">zOS</a>
        <a href="ai.html">zAI</a>
        <a href="docs.html">Docs</a>
    </nav>
</header>

<div class="hero">
    <h1>Il linguaggio. Il sistema operativo. L’ecosistema vivente.</h1>
    <p>ZEN ora include un terminale reale nel browser.</p>
</div>

<div class="section">
    <h2 class="section-title">Terminale ZEN (reale)</h2>

    <div id="zen-terminal" class="terminal">
$ Benvenuto nel terminale ZEN
$ Digita un comando e premi INVIO
    </div>

    <input id="zen-input"
           style="width:100%; padding:10px; margin-top:10px; font-family:monospace;"
           placeholder="Esempio: 10 20 + print">
</div>

<script src="terminal.js"></script>
<script>zen_terminal_init()</script>

</body>
</html>
EOF

###############################################
# 3) BUILD COMPLETO
###############################################

echo "[BUILD] Compilazione core..."
mkdir -p build/core
cp -r src/* build/core/

###############################################
# 4) COMMIT + PUSH AUTOMATICO
###############################################

echo "[GIT] Commit & push..."

git add .
git commit -m "ZEN ULTRA AUTOBUILD: terminale reale + CLI + site update"
git push

echo "=== COMPLETATO ==="
EOF
