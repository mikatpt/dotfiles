# Navigation

function cs; cd $argv; ls -A; end
function sc; cd ..; ls -A; end
function csa; cd $argv; ls -Ahl; end
function sca; cd ..; ls -Ahl; end

function ..; cd ..; end
function ...; cd ../..; end
function ....; cd ../../..; end

function ffs; eval sudo $history[1]; end

# Git

function co; git checkout $argv; end
function s; git status $argv; end

function st; git stash $argv; end
function sd; git stash drop $argv; end
function sp; git stash pop $argv; end
function sa; git stash apply $argv; end
function sl; git stash list $argv; end

