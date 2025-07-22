def main [path?: string] {
  let dir = if $path != null {
    if ($path | split chars | first) == '/' {
      $path
    } else {
      (pwd) | path join $path
    }
  } else {
    $env.HOME + "/dotfiles/scripts/"
  };

  if ($dir | path type | describe) == nothing {
    print "Error: path does not exist: " $dir
  }
  if ($dir | path type) != "dir" {
    print "Error: Is not a directory: " $dir
  }
  
  let entries = (ls $dir | get name | path parse );
  let pick = ($entries | get stem | to text) | wofi -d -i -p "Launch script"

  let script = $entries | where { ($pick ) == $in.stem } | first | $in.parent + "/" + $in.stem + "." + $in.extension;

  (nu $script)
}
