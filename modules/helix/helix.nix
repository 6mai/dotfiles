{ lib, pkgs, config, ... }:

{
  programs.helix = {
  	enable = true;
  	defaultEditor = true;

  	settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        file-picker.hidden = false;
      };
      keys = {
        normal = {
          V = [ "extend_line" "select_mode" ];
          C-k = "kill_to_line_end";
          A-x = "command_palette";
          h = "goto_word";
          space = {
            "." = "file_picker_in_current_buffer_directory";
            "," = "buffer_picker";
            H = ":toggle lsp.display-inlay-hints";
          };
        };
        insert = {
          C-c = "normal_mode";
          C-g = "normal_mode";
          C-k = "kill_to_line_end";
        };
        select = {
          C-g = "normal_mode";
          C-c = "normal_mode";
          h = "goto_word";
        };
      };
    };

    languages = {
      language = [
        {
          name = "rust";

          debugger = {
            command = "codelldb";
            name = "codelldb";
            port-arg = "--port {}";
            transport = "tcp";

            templates = [{
              name = "binary";
              request = "launch";

              completion = [{
                completion = "filename";
                name = "binary";    
              }];

              args = {
                program = "{0}";
                runInTerminal = false;
              };
            }];
          };
        }
      ];
    };
	};
}
