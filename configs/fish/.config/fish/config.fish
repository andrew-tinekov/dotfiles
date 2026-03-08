set fish_greeting

set -gx EDITOR nvim

if test (uname) = Darwin
    brew shellenv | source
else if command -v mise &>/dev/null
    mise activate fish | source
end
