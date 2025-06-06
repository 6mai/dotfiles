$env.ODIN_ROOT = "C:\\Users\\station\\.odin";
alias c = clear;
alias cdpr = cd F:\\Projects\\;
alias co = cd C:\Users\station\.odin\;
alias p1 = cd F:\Projects\learning_examples\iced-rs;
alias p2 = cd F:\Projects\learning_examples\egui;
alias p4 = cd F:\Projects\learning_examples\web\css\course1\;
alias p6 = cd F:\Projects\learning_examples\web\axum\intro;
alias p3 = cd F:\Projects\live_server\rust_live_server;
alias p7 = cd F:\Projects\learning_examples\games\macroquad_book;
alias p5 = cd F:\Projects\knowledge_vault\kv_server;
alias wr = cd F:\writing\;
alias nu-cfg = hx $nu.config-path;
alias ll = ls -la

let aliases = {
  c: "clear"
};

$env.config.show_banner = false;
source ~/.zoxide.nu;

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

# 『涸れ森』と呼ばれる場所になった。私が〝人〟であり、クァール"

def replace_annoying_chars_from_epubs [path: string] {
  let name = $path | path parse | get stem;
  let name = "temp"
  (mkdir $name)

  (7z x -o($name) $path)
  (cd $name)

  let fnr = [[find, replace]; ["\'", '〝'], ["\'", '〟']];
  let xhtmls = (ls **/* | find .xhtml);

  for file in $xhtmls {
  mut text = (open $file.name);
    for find in $fnr {
      $text = $text | str replace $find.find $find.replace
    }
    
    let filename = $file.name;
    print $filename

(open $file.name)
   ($text | save -f $filename)
  }
  (cd ..)

  (7z a -tzip ($name + "_mod.epub") ("./" + $name + "/*"))

  (rm -r $name)
}

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
