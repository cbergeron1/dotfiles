# TODO: ENTIRE FILE

# Bring in exports, aliases, and functions
for file in ~/.{exports,aliases,functions}; do
        [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Tab completion for SSH hostnames
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;
