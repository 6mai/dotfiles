# const compositor = "sway";
const compositor = "hyprland";

let get_monitor = if $compositor == "sway" {
 (swaymsg -t get_outputs | from json | where { ($in | get focused) == true } | get name.0) 
} else if $compositor == "hyprland" {
 let s = (hyprctl -j monitors | from json | where { $in.focused == true } | $in.0 | get name);
 $s
} else {
  "No compositor set"
};

let get_focused_window = if $compositor == "hyprland" {
    (hyprctl -j activewindow | from json | $"($in.at.0),($in.at.1) ($in.size.0)x($in.size.1)")
} else if $compositor == "sway" {
     let node = n (swaymsg -t get_tree | from json);
    let rect = $node | get rect;
    let wrect = $node | get window_rect;
    let x = $rect.x + $wrect.x;
    let y = $rect.y + $wrect.y;
    $"($x),($y) ($wrect.width)x($wrect.height)" 
}

  def n [it: record] {
    if ($it | get focused) == true {
      return ($it);
    } else {
      for node in ($it | get nodes) {
        let res = n $node;
        if $res != null {
          return $res;
        }
      }
      return null;
    }
  }

def main [ x?: string ] {
  let prompt = "What to screenshot";
  let mon = "Monitor";
  let sel = "Selection";
  let all = "All screens";
  let focused = "Focused window";
  let clip = "Save to clipboard";
  let color = "Color picker";

  let opts = [$sel, $mon, $all, $focused, $clip, $color, ] | str join "\n";
  let pick = if $x == null {
    ($opts | wofi -d -i -p $prompt)
  } else {
    $x
  };

  if $pick == $sel {
    (grim -g (slurp));
    print $sel;
  } else if $pick == $mon {
    let m = $get_monitor;
    (grim -o $m);
    print $mon  
  } else if $pick == $all {
    (grim);
    print $all;
  } else if $pick == $focused {
    (grim -g $get_focused_window)
    print $focused;
  } else if $pick == $clip {
    (grim - | wl-copy)
    print $clip
  } else if $pick == $color {
    (grim -g (slurp) -t ppm - | magick - -format '%[pixel]:p{0,0}' txt:- | split row "\n" | parse "{x},{y}: {srbg}  {hex}  {rest}" | first | get hex | wl-copy)
  } else {
     print "No match or canceled"  
  }

  # match $pick {
  #  # this is how you fucking match if you pass a variable to it GARBAGe
  #   $m if $mon == $m => {
  #     (grim -o (swaymsg -t get_outputs | from json | filter {|it| ($it | get focused) == true } | get name.0));
  #     print $mon;
  #   },
  #   $sel => {
  #     (grim -g (slurp));
  #     print $sel;
  #   },
  #   $all => {
  #     (grim);
  #      print $all
  #   },
  #   $focused => {
  #     let node = n (swaymsg -t get_tree | from json);
  #     let rect = $node | get rect;
  #     let wrect = $node | get window_rect;
  #     let x = $rect.x + $wrect.x;
  #     let y = $rect.y + $wrect.y;
  #     (grim -g $"($x),($y) ($wrect.width)x($wrect.height)");
  #     print $focused;
  #   },
  #   $clip => {
  #     (grim - | wl-copy)
  #     print $clip
  #   }
  #   _ => {print "No match or canceled"}  
  # } 
}

