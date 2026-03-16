#!/bin/bash

echo "=== ZEN ULTIMATE AUTOBUILD ==="

# ---------------------------------------------------------
# 0) PREPARAZIONE AMBIENTE
# ---------------------------------------------------------

mkdir -p src
mkdir -p src/std
mkdir -p src/compiler
mkdir -p src/runtime
mkdir -p src/distributed
mkdir -p src/zcore
mkdir -p src/debugger
mkdir -p src/transpilers

mkdir -p docs
mkdir -p docs/zcore
mkdir -p docs/debugger
mkdir -p docs/transpilers

mkdir -p examples
mkdir -p examples/zcore
mkdir -p examples/debugger
mkdir -p examples/transpilers

mkdir -p tests
mkdir -p tests/zcore
mkdir -p tests/debugger
mkdir -p tests/transpilers

mkdir -p site/assets

# ---------------------------------------------------------
# 1) GENERAZIONE LINGUAGGIO ZEN COMPLETO
# ---------------------------------------------------------

cat > src/tokenizer.zc << 'EOF'
KEYWORDS = ["node","mesh","shield","worker","start","sync","raise","spawn","if","type"]

class Token:
    def __init__(self, type, value):
        self.type = type
        self.value = value

def classify(word):
    if word in KEYWORDS:
        return Token("KEYWORD", word)
    if word.isalpha():
        return Token("IDENTIFIER", word)
    return Token("UNKNOWN", word)

def tokenize(source):
    tokens = []
    current = ""
    for char in source:
        if char.isspace():
            if current:
                tokens.append(classify(current))
                current = ""
        elif char in [".", ":"]:
            if current:
                tokens.append(classify(current))
                current = ""
            tokens.append(Token("SYMBOL", char))
        else:
            current += char
    if current:
        tokens.append(classify(current))
    return tokens
EOF

cat > src/parser.zc << 'EOF'
class Node:
    def __init__(self, type, args=None):
        self.type = type
        self.args = args or {}

def parse(tokens):
    ast = []
    i = 0
    while i < len(tokens):
        t = tokens[i]
        if t.value == "node":
            ast.append(Node("NODE_START"))
        if t.value == "mesh":
            ast.append(Node("MESH_SYNC"))
        if t.value == "shield":
            ast.append(Node("SHIELD_RAISE"))
        if t.value == "worker":
            ast.append(Node("WORKER_SPAWN"))
        i += 1
    return ast
EOF

cat > src/ast.zc << 'EOF'
class ASTNode:
    def __init__(self, type, args=None):
        self.type = type
        self.args = args or {}
EOF

cat > src/runtime/runtime.zc << 'EOF'
class Runtime:
    def __init__(self):
        self.state = {
            "node": "stopped",
            "mesh": "idle",
            "shield": "down",
            "workers": []
        }

    def execute(self, ast):
        for node in ast:
            if node.type == "NODE_START":
                self.state["node"] = "running"
            if node.type == "MESH_SYNC":
                self.state["mesh"] = "synced"
            if node.type == "SHIELD_RAISE":
                self.state["shield"] = "raised"
            if node.type == "WORKER_SPAWN":
                self.state["workers"].append("worker")
        return self.state
EOF

cat > src/compiler/compiler.zc << 'EOF'
BYTECODES = {
    "NODE_START": 1,
    "MESH_SYNC": 2,
    "SHIELD_RAISE": 3,
    "WORKER_SPAWN": 4
}

def compile(ast):
    bytecode = []
    for node in ast:
        bytecode.append(BYTECODES[node.type])
    return bytecode
EOF

# ---------------------------------------------------------
# 2) ZCORE COMPLETO
# ---------------------------------------------------------

cat > src/zcore/opcodes.zc << 'EOF'
OPCODES = {
    "NODE_START": 16,
    "NODE_STOP": 17,
    "MESH_SYNC": 32,
    "MESH_BROADCAST": 33,
    "SHIELD_RAISE": 48,
    "SHIELD_LOWER": 49,
    "WORKER_SPAWN": 64,
    "WORKER_KILL": 65
}
EOF

cat > src/zcore/bridge.zc << 'EOF'
from src.zcore.opcodes import OPCODES

ZEN_TO_ZCORE = {
    "NODE_START": OPCODES["NODE_START"],
    "MESH_SYNC": OPCODES["MESH_SYNC"],
    "SHIELD_RAISE": OPCODES["SHIELD_RAISE"],
    "WORKER_SPAWN": OPCODES["WORKER_SPAWN"]
}

def translate(ast):
    bytecode = []
    for node in ast:
        if node.type in ZEN_TO_ZCORE:
            bytecode.append(ZEN_TO_ZCORE[node.type])
    return bytecode
EOF

cat > src/zcore/runtime.zc << 'EOF'
class ZCoreRuntime:
    def __init__(self):
        self.state = {
            "node": "stopped",
            "mesh": "idle",
            "shield": "down",
            "workers": []
        }

    def execute_opcode(self, opcode):
        if opcode == 16:
            self.state["node"] = "running"
        if opcode == 17:
            self.state["node"] = "stopped"
        if opcode == 32:
            self.state["mesh"] = "synced"
        if opcode == 33:
            self.state["mesh"] = "broadcast"
        if opcode == 48:
            self.state["shield"] = "raised"
        if opcode == 49:
            self.state["shield"] = "lowered"
        if opcode == 64:
            self.state["workers"].append("worker")
        if opcode == 65:
            if self.state["workers"]:
                self.state["workers"].pop()
        return self.state
EOF

cat > src/zcore/loader.zc << 'EOF'
from src.zcore.runtime import ZCoreRuntime

class ZCoreLoader:
    def __init__(self):
        self.runtime = ZCoreRuntime()

    def load(self, bytecode):
        for op in bytecode:
            self.runtime.execute_opcode(op)
        return self.runtime.state
EOF

# ---------------------------------------------------------
# 3) DEBUGGER COMPLETO
# ---------------------------------------------------------

cat > src/debugger/ast_viewer.zc << 'EOF'
def view_ast(ast):
    print("AST VIEW")
    for node in ast:
        print(" -", node.type)
EOF

cat > src/debugger/bytecode_viewer.zc << 'EOF'
def view_bytecode(bytecode):
    print("BYTECODE VIEW")
    for op in bytecode:
        print(" -", op)
EOF

cat > src/debugger/runtime_inspector.zc << 'EOF'
def inspect_runtime(state):
    print("RUNTIME STATE")
    for key in state:
        print(key, ":", state[key])
EOF

cat > src/debugger/debugger.zc << 'EOF'
from src.tokenizer import tokenize
from src.parser import parse
from src.compiler.compiler import compile
from src.zcore.bridge import translate
from src.zcore.loader import ZCoreLoader

from src.debugger.ast_viewer import view_ast
from src.debugger.bytecode_viewer import view_bytecode
from src.debugger.runtime_inspector import inspect_runtime

class ZenDebugger:
    def __init__(self):
        self.loader = ZCoreLoader()

    def debug(self, source):
        print("TOKENIZING")
        tokens = tokenize(source)

        print("PARSING")
        ast = parse(tokens)

        print("AST")
        view_ast(ast)

        print("COMPILING")
        bytecode = compile(ast)

        print("BYTECODE")
        view_bytecode(bytecode)

        print("TRANSLATING TO ZCORE")
        zcore_code = translate(ast)

        print("EXECUTING")
        state = self.loader.load(zcore_code)

        print("RUNTIME")
        inspect_runtime(state)

        return state
EOF

# ---------------------------------------------------------
# 4) TRANSPILERS COMPLETI
# ---------------------------------------------------------

cat > src/transpilers/json.zc << 'EOF'
import json

def zen_to_json(ast):
    output = []
    for node in ast:
        output.append({
            "type": node.type,
            "args": node.args
        })
    return json.dumps(output, indent=2)
EOF

cat > src/transpilers/yaml.zc << 'EOF'
def zen_to_yaml(ast):
    lines = []
    for node in ast:
        lines.append("- type: " + node.type)
        if node.args:
            for k in node.args:
                lines.append("  " + k + ": " + str(node.args[k]))
    return "\n".join(lines)
EOF

cat > src/transpilers/python.zc << 'EOF'
def zen_to_python(ast):
    lines = ["program = []"]
    for node in ast:
        lines.append("program.append({\"type\": \"" + node.type + "\", \"args\": " + str(node.args) + "})")
    return "\n".join(lines)
EOF

cat > src/transpilers/zcore_native.zc << 'EOF'
from src.zcore.bridge import ZEN_TO_ZCORE

def zen_to_zcore_native(ast):
    lines = []
    for node in ast:
        if node.type in ZEN_TO_ZCORE:
            opcode = ZEN_TO_ZCORE[node.type]
            lines.append("OP " + str(opcode))
    return "\n".join(lines)
EOF

# ---------------------------------------------------------
# 5) GIT DEPLOY
# ---------------------------------------------------------

git add .
git commit -m "ZEN FULL AUTOBUILD"
git push

echo "=== ZEN ULTIMATE AUTOBUILD COMPLETE ==="
