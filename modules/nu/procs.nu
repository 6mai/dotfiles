# copy default dev flake into a folder
def dev-envs [] {
  let dir = $env.HOME + "/dotfiles/dev_envs/"
  
  let entries = (ls $dir | get name | path parse );
  let pick = ($entries | get stem | to text) | wofi -d -i -p "Launch script"

  let flake_path = $entries | where { ($pick ) == $in.stem } | first | $in.parent + "/" + $in.stem + "." + $in.extension;
  let dest = ((pwd) | path join "flake.nix");

  (cp $flake_path $dest)
  print "Copied development flake!"
}

# generates rust docs for primary dependencies only
def primary_deps [echo?: string] {
  let full_command = $"cargo doc --no-deps (cargo tree --depth 1 | parse '{tree} {dep} {ver}' | skip 1 | select dep | reduce -f '' {|elt, acc| $acc + ' -p ' + $elt.dep}) --open"
  if $echo != null {
    print $full_command
  } else {
    (nu -c $full_command)
   }
}
def tt [...cont] {
  $cont | each  { | it |
    print $it
  }
}


# fixing LN ship that online TTS reads wrong
# 『涸れ森』と呼ばれる場所になった。私が〝人〟であり、クァール"

def find_and_replace [input: string, find: string, replace: string] {
  $input | str replace --all $find $replace 
}

def rep [] {
  let fnr = [[find, replace]; ["〝", "-"], ["〟", "-"]];
  let xhtmls = (ls | find .xhtml);

  for file in $xhtmls {
    mut text = (open $file.name);
    for find in $fnr {
      $text = (find_and_replace $text $find.find $find.replace)
    }
    
    let filename = $file.name;
    print $filename
    print (pwd)

    (open $file.name)
    $text | save ($filename)
  }
}

def replace_annoying_chars_epubs [path: string] {
  let name_wo_ext = $path | path parse | get stem;
  let name = "_temp_13";
  (mkdir $name)

  (7z x -o($name) $path)
  (cd $name)
  (cd OEBPS/Text/)
  let fnr = [[find, replace]; ["〝", "-"], ["〟", "-"]];
  let xhtmls = (ls | find .xhtml);

  for file in $xhtmls {
    mut text = (open $file.name);
    for find in $fnr {
      $text = (find_and_replace $text $find.find $find.replace)
    }
    
    let filename = $file.name;
    print $filename
    print (pwd)

    (open $file.name)
    $text | save ($filename)
  }
  (cd ../../../)

  (7z a -tzip ($name_wo_ext + "_mod.epub") ("./" + $name + "/*"))

  (rm -r $name)
}


# turn rar files to zip so comicrack can read them
def rar2zip [path?: string] {
  let temp_name = "_" + (random uuid);
  let file_name = ($path | default '') | path parse | get stem; 
  let dir_path = if ($path | path parse | get parent) == "" {
    "./"
  } else {
        ($path | path parse | get parent) + "/"
  };
  
  (mkdir $temp_name);
  
  let uncompress = (7z x -o($temp_name) $path | complete);
  if $uncompress.exit_code != 0 {
        print $uncompress.stderr;
        print $uncompress.stdout;
  } else {
        let zipping = (7z a -tzip ($dir_path + $file_name + ".zip") ("./" + $temp_name + "/*") | complete);    
        if $zipping.exit_code != 0 {
            print $zipping.stderr;
            print $zipping.stdout;
        } else {
            (rm $path)
        }
  }

  (rm -r $temp_name)
}

def avif2zip [path?: string] {
  let temp_folder = "_temp_folder" ;
  (mkdir $temp_folder)

  (magick mogrify -format png -path $temp_folder (($path | default '') + "*.avif"))

  let zipping = (7z a -tzip (pwd | path basename) ("./" + $temp_folder + "/*") | complete);
  
  if $zipping.exit_code != 0 {
      print $zipping.stderr;
      print $zipping.stdout;
  } 
  (rm -r $temp_folder)
}

def to_from_img [to, from] {
  let temp_folder = "_temp_folder" ;
  (mkdir $temp_folder)

  (magick mogrify -format $to -path $temp_folder ("*." + $from))

}
