#!/bin/bash

echo "=== ZEN AUTOBUILD TOTAL SYSTEM ==="

###############################################
# 1) AUTO-FILL: crea file mancanti
###############################################

echo "[STEP 1] Riempimento file mancanti..."

for module in modules/*; do
  mkdir -p $module/src
  mkdir -p $module/docs
  mkdir -p $module/tests
  mkdir -p $module/examples

  # build.sh
  if [ ! -f "$module/build.sh" ]; then
    echo "[FIX] build.sh creato per $module"
    cat > $module/build.sh << EOF
#!/bin/bash
echo "Building $(basename $module)"
EOF
    chmod +x $module/build.sh
  fi

  # src file
  if [ ! -f "$module/src/main.zc" ]; then
    echo "[FIX] main.zc creato per $module"
    echo "// Auto-generated module file" > $module/src/main.zc
  fi

  # docs
  if [ ! -f "$module/docs/overview.md" ]; then
    echo "[FIX] overview.md creato per $module"
    echo "# $(basename $module)" > $module/docs/overview.md
    echo "Documentazione generata automaticamente." >> $module/docs/overview.md
  fi
done


###############################################
# 2) BUILD CORE
###############################################

echo "[STEP 2] Build core..."
mkdir -p build/core
cp -r src/* build/core/


###############################################
# 3) BUILD MODULES
###############################################

echo "[STEP 3] Build moduli..."

for module in modules/*; do
  if [ -f "$module/build.sh" ]; then
    echo "[BUILD] $module"
    bash "$module/build.sh"
  else
    echo "[WARN] Nessun build.sh in $module"
  fi
done


###############################################
# 4) GENERAZIONE SITO COMPLETO
###############################################

echo "[STEP 4] Generazione sito GitHub Pages..."

mkdir -p docs

# CSS
cat > docs/style.css << 'EOF'
body {
    margin: 0;
    font-family: "Inter", sans-serif;
    background: #0d0d0d;
    color: #e6e6e6;
}
header {
    padding: 40px;
    text-align: center;
    background: #111;
    border-bottom: 1px solid #222;
}
nav a {
    margin: 0 15px;
    color: #aaa;
    text-decoration: none;
    font-weight: bold;
}
nav a:hover {
    color: #fff;
}
.section {
    padding: 60px 20px;
    max-width: 900px;
    margin: auto;
}
.card {
    background: #141414;
    padding: 20px;
    border-radius: 10px;
    border: 1px solid #222;
    margin-bottom: 20px;
}
EOF

# INDEX
cat > docs/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>ZEN Framework</title>
<link rel="stylesheet" href="style.css">
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
<div class="section">
    <h2>Benvenuto in ZEN</h2>
    <p>Il linguaggio. Il sistema operativo. L’ecosistema vivente.</p>
</div>
</body>
</html>
EOF

# MODULES
cat > docs/modules.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>Moduli ZEN</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<header>
    <h1>Moduli ZEN</h1>
    <nav>
        <a href="index.html">Home</a>
        <a href="modules.html">Moduli</a>
        <a href="os.html">zOS</a>
        <a href="ai.html">zAI</a>
        <a href="docs.html">Docs</a>
    </nav>
</header>
<div class="section">
    <h2>Moduli Principali</h2>
    <div class="card"><h3>zVM</h3><p>Virtual Machine stack-based.</p></div>
    <div class="card"><h3>zASM</h3><p>Assembler ufficiale.</p></div>
    <div class="card"><h3>zNET</h3><p>Networking astratto.</p></div>
    <div class="card"><h3>zSEC</h3><p>Sicurezza e sandbox.</p></div>
    <div class="card"><h3>zBOOT</h3><p>Bootloader del micro‑OS.</p></div>
</div>
</body>
</html>
EOF

# OS
cat > docs/os.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>zOS</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<header>
    <h1>zOS — ZEN Operating System</h1>
    <nav>
        <a href="index.html">Home</a>
        <a href="modules.html">Moduli</a>
        <a href="os.html">zOS</a>
        <a href="ai.html">zAI</a>
        <a href="docs.html">Docs</a>
    </nav>
</header>
<div class="section">
    <h2>Kernel</h2>
    <p>Scheduler, memory manager, process manager, device manager.</p>
    <h2>Servizi</h2>
    <p>logger, networkd, timed, eventd, registry.</p>
</div>
</body>
</html>
EOF

# AI
cat > docs/ai.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>zAI</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<header>
    <h1>zAI — Artificial Intelligence Module</h1>
    <nav>
        <a href="index.html">Home</a>
        <a href="modules.html">Moduli</a>
        <a href="os.html">zOS</a>
        <a href="ai.html">zAI</a>
        <a href="docs.html">Docs</a>
    </nav>
</header>
<div class="section">
    <h2>Funzionalità</h2>
    <p>Analisi AST, ottimizzazione, auto-documentazione.</p>
</div>
</body>
</html>
EOF

# DOCS
cat > docs/docs.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
<title>Documentazione ZEN</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<header>
    <h1>Documentazione ZEN</h1>
    <nav>
        <a href="index.html">Home</a>
        <a href="modules.html">Moduli</a>
        <a href="os.html">zOS</a>
        <a href="ai.html">zAI</a>
        <a href="docs.html">Docs</a>
    </nav>
</header>
<div class="section">
    <h2>Documentazione Generata</h2>
    <p>La documentazione completa è generata automaticamente dal sistema autobuild.</p>
</div>
</body>
</html>
EOF


###############################################
# 5) GIT COMMIT & PUSH
###############################################

echo "[STEP 5] Commit & push..."

git add .
git commit -m "ZEN AUTOBUILD: build + auto-fill + site"
git push

echo "=== AUTOBUILD TOTALE COMPLETATO ==="
