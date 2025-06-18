$env.SWWW_TRANSITION_FPS? | default "-60"
$env.SWWW_TRANSITION_STEP? | default "-2"
let resize_type = "fit";
const default_interval = 600;

def main [ file? ] {
    if $file != null {
      (swww img --resize $resize_type $file);
      return;
    }

    let pick = (["Set" "Random" "Cycle" "Cycle_random"] | to text | wofi -d -i -p "Choose mode")

    match $pick {
      "Set" => {
        let file = (ls **/* | get name | filter { ($in | path type) == "file" } | to text | wofi -d -i -p "Pick Wallpaper");
        (swww img --resize $resize_type $file);
      }
      "Random" => {
        let prompt = "Selects a random wallpaper from a directory";
        let dir = (ls **/* | get name | filter { ($in | path type) == "dir" } | to text | wofi -d -i -p $prompt);
        pick_random $dir
      }
      "Cycle" => {
        let prompt = "Cycles through wallpapers in a directory";
        let dir = (ls **/* | get name | filter { ($in | path type) == "dir" } | to text | wofi -d -i -p $prompt);
        cycle $dir
  
      }
      "Cycle_random" => {
        let prompt = "Randomly cycles through wallpapers in a directory";
        let dir = (ls **/* | get name | filter { ($in | path type) == "dir" } | to text | wofi -d -i -p $prompt);
        cycle_random $dir
      }
      _ => {}    
    }
}

def "main cycle" [ dir interval?: int = $default_interval ] {
  cycle $dir $interval
}

def "main cycle_random" [ dir? interval?: int = $default_interval ] {
  cycle_random $dir $interval
}

def "main random" [ dir ] {
  pick_random $dir
}

def cycle [ dir interval?: int = $default_interval ] {
  let entries = (ls $dir);
  let len = ($entries | length);
  mut pick = random int  0..<$len;

  loop {
    let entries = (ls $dir);
    let len = ($entries | length);
    $pick = ($pick + 1) mod $len;
    (swww img --resize $resize_type ($entries | get $pick | get name ));
    (sleep ($interval | into duration --unit sec));
  }
}

# "ported" https://github.com/LGFae/swww/blob/main/example_scripts/swww_randomize.sh
# idk the shitty bash syntax so I just freestyled most of it
def cycle_random [ dir? interval?: int = $default_interval ] {
  if $dir == null {
    print "USAGE:" "\t[DIRECTORY] <INTERVAL>"  
    print $"\tChanges the wallpaper to a randomly chosen image in DIRECTORY every\n\tINTERVAL seconds \(or every ($interval) seconds if unspecified\)." 
    (exit 1);
  }
  loop {
    let entries = (ls $dir);
    let pick = random int  0..<($entries | length);
    (swww img --resize $resize_type ($entries | get $pick | get name ));
    (sleep ($interval | into duration --unit sec));
  }
}

def pick_random [ dir ] {
    let entries = (ls $dir);
    let pick = random int  0..<($entries | length);
    (swww img --resize $resize_type ($entries | get $pick | get name ));
}

