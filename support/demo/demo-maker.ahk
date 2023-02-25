; --------------------------------------------------
; This script generates the demo gif
; NOTE: This should be executed in the root folder
; --------------------------------------------------
#SingleInstance Force
SetkeyDelay 0, 50

Outfile := "cast.svg"
Template := "window_frame"

Return

Type(Command, Delay=2000) {
  Send % Command
  Sleep 500
  Send {Enter}
  Sleep Delay
}

F12::
  Type("{#} Press F11 to abort at any time")
  Type("cd ./support/demo")
  Type("rm -rf myapp")
  ; Type("termtosvg " Outfile " -t " Template)
  Type("rm cast.json {;} asciinema rec cast.json")

  Type("mkdir myapp && cd ./myapp")
  Type("bashly")

  Type("{#} Create a sample Bashly configuration file", 500)
  Type("bashly init")
  Type("vi src/bashly.yml", 4000)
  Type(":exit", 500)

  Type("{#} Generate the bash script", 500)
  Type("bashly generate")
  
  Type("{#} Run the bash script", 500)
  Type("./cli")
  Type("./cli --help")
  Type("./cli download -h")
  Type("./cli download")
  Type("./cli download somefile")
  Type("./cli download somefile --force")

  ; Type("{#} Replace the download function with your code", 500)
  ; Type("cat src/cli_download_command.sh")
  ; Type("echo 'echo downloading ${{}args[source]{}}' > src/cli_download_command.sh")

  ; Type("{#} Regenerate to merge the updated function", 500)
  ; Type("bashly generate")

  ; Type("{#} Run the bash script again", 500)
  ; Type("./cli download the-internet")

  Type("exit")
  Type("agg --font-size 20 cast.json cast.gif")
  Sleep 400
  Type("cd ../../")
  Type("{#} Done")
Return

^F12::
  Reload
return

F11::
  ExitApp
return
