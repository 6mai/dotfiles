
def main [] {
  let dir = $env.HOME + "/dotfiles/dev-envs/"
  
  let entries = (ls $dir | get name | path parse );
  let pick = ($entries | get stem | to text) | wofi -d -i -p "Launch script"

  let flake_path = $entries | where { ($pick ) == $in.stem } | first | $in.parent + "/" + $in.stem + "." + $in.extension;

  (cp $flake_path ((pwd) | path join "flake.nix"))
}
