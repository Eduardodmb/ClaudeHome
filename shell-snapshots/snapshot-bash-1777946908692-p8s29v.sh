# Snapshot file
# Unset all aliases to avoid conflicts with functions
unalias -a 2>/dev/null || true
shopt -s expand_aliases
# Check for rg availability
if ! (unalias rg 2>/dev/null; command -v rg) >/dev/null 2>&1; then
  function rg {
  local _cc_bin="${CLAUDE_CODE_EXECPATH:-}"
  [[ -x $_cc_bin ]] || _cc_bin=/c/Users/eduar/.local/bin/claude.exe
  if [[ ! -x $_cc_bin ]]; then command rg "$@"; return; fi
  if [[ -n $ZSH_VERSION ]]; then
    ARGV0=rg "$_cc_bin" "$@"
  elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "win32" ]]; then
    ARGV0=rg "$_cc_bin" "$@"
  elif [[ $BASHPID != $$ ]]; then
    exec -a rg "$_cc_bin" "$@"
  else
    (exec -a rg "$_cc_bin" "$@")
  fi
}
fi
export PATH='/c/Users/eduar/bin:/mingw64/bin:/usr/local/bin:/usr/bin:/bin:/mingw64/bin:/usr/bin:/c/Users/eduar/bin:/c/Program Files (x86)/Common Files/Oracle/Java/java8path:/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/c/Program Files (x86)/VMware/VMware Workstation/bin:/c/WINDOWS/system32:/c/WINDOWS:/c/WINDOWS/System32/Wbem:/c/WINDOWS/System32/WindowsPowerShell/v1.0:/c/WINDOWS/System32/OpenSSH:/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn:/c/Program Files/Microsoft SQL Server/150/Tools/Binn:/c/Program Files/dotnet:/c/Program Files/Microsoft SQL Server/130/Tools/Binn:/c/php/php-82:/c/ProgramData/ComposerSetup/bin:/c/Program Files/Docker/Docker/resources/bin:/c/Program Files (x86)/Bitvise SSH Client:/c/Program Files/nodejs:/c/Program Files (x86)/Windows Kits/10/Windows Performance Toolkit:/cmd:/c/Program Files/Pandoc:/c/Program Files/GitExtensions:/c/Users/eduar/.local/bin:/c/Users/eduar/AppData/Local/pnpm:/c/Users/eduar/AppData/Local/Microsoft/WindowsApps:/c/Users/eduar/AppData/Local/Programs/Microsoft VS Code/bin:/c/Users/eduar/.dotnet/tools:/c/Users/eduar/AppData/Roaming/Composer/vendor/bin:/c/Users/eduar/AppData/Roaming/npm:/c/Users/eduar/AppData/Local/Python/bin:/c/Users/eduar/AppData/Local/Programs/cursor/resources/app/bin:/usr/bin/vendor_perl:/usr/bin/core_perl'
