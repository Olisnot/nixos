{ pkgs, ... }:

let
  tmux = "${pkgs.tmux}/bin/tmux";
in
pkgs.writers.writePython3Bin "code" { } /* python */''
import os
import subprocess

repositoryPath = "/home/oliver/repos"
find = subprocess.Popen(["ls", repositoryPath], stdout=subprocess.PIPE)
fzfPath = "${pkgs.fzf}/bin/fzf"
fzf = subprocess.run((fzfPath), stdin=find.stdout, capture_output=True)
find.wait()
repo = fzf.stdout.decode("utf-8")
repo = repo.removesuffix("\n")
repoPath = repositoryPath + "/" + repo
os.chdir(repoPath)
tmT = "${tmux}"
ns = "new-session"
subprocess.Popen([tmT, ns, "-d", "-s", repo, "-n", "NeoVim"])

t = os.environ["TERM"]
termState = subprocess.run(["echo", t], capture_output=True)
term = termState.stdout.decode("utf-8").removesuffix("\n")

if term == "screen":
    subprocess.Popen([tmT, "switch", "-t", repo])
    ''
