def main [ wr?: int ] {
	let wr = if $wr == null {
    (0..9 | to text | wofi -d -i -p "Switch to workroom") | into int 
  } else {
    $wr
  };

  # doesn't work
  (swaymsg $"'set \"$$workroom\" ($wr); workspace ($wr)$$workspace'")
  
} 
