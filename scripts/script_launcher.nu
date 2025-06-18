def main [] {
  let dir = $env.HOME + "/dotfiles/scripts/";
  let entries = (ls $dir | get name | path parse );
  let pick = ($entries | get stem | to text) | wofi -d -i -p "Launch script"

  let script = $entries | filter { ($pick | split words | first) == $in.stem } | first | $in.parent + "/" + $in.stem + "." + $in.extension;

  (nu $script)
}
