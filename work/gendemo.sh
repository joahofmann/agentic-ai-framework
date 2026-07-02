#!/bin/bash
set -e

mkdir -p ~/agentic/notebooks

cat > ~/agentic/notebooks/demo.ipynb <<'NB'
{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": [
    "# ============================================================\n",
    "# AGENTIC AI FRAMEWORK DEMO\n",
    "# ============================================================\n",
    "\n",
    "import os\n",
    "import sys\n",
    "\n",
    "PROJECT_ROOT = os.path.abspath('/home/jovyan/agentic')\n",
    "sys.path.insert(0, PROJECT_ROOT)\n",
    "\n",
    "from agentic.agents import run_demo_agent\n",
    "\n",
    "result = run_demo_agent()\n"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python (agentic)",
   "language": "python",
   "name": "agentic"
  },
  "language_info": {
   "name": "python"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
NB

echo
echo "Notebook created:"
echo "/home/jovyan/agentic/notebooks/demo.ipynb"
