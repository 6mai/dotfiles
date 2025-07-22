
def main [] {
  let dir = $env.HOME + "/dotfiles/dev_envs/"
  
  let entries = (ls $dir | get name | path parse );
  let pick = ($entries | get stem | to text) | wofi -d -i -p "Launch script"

  let flake_path = $entries | where { ($pick ) == $in.stem } | first | $in.parent + "/" + $in.stem + "." + $in.extension;
  let dest = ((pwd) | path join "flake.nix");
  print "fp: " $flake_path "|||| dest: " $dest

  (cp $flake_path $dest)
}
