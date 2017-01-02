function! GitRoot()
  " Drop extraneous characters at the end of returned git string
  return system("git rev-parse --show-toplevel")[0:-2]
endfunction

function! PathToGuard(path)
  let guard_str = toupper(a:path)
  let guard_str = substitute(guard_str, '\/', '_', 'g')
  return substitute(guard_str, '\.', '_', 'g').'_'
endfunction

let s:lineNum = 3
function! PrintLine(content)
  call setline(s:lineNum, a:content)
  let s:lineNum += 1
endfunction

function! AddNamespaceAndHashGuard()
  let file_path = expand('%:p')
  let git_root = GitRoot()
  if matchstr(file_path, git_root) == ""
    " File is not under current git root.
    return
  endif
  let relative_path = file_path[strlen(git_root)+1:]
  let directories = split(relative_path, '/')[0:-2]
  let guard_str = PathToGuard(relative_path)
  call PrintLine('')  " Empty line.
  call PrintLine('#ifndef ' . guard_str)
  call PrintLine('#define ' . guard_str)
  call PrintLine('')  " Empty line.

  for dir in directories
    call PrintLine('namespace ' . dir . ' {')
  endfor

  call PrintLine('')

  call reverse(directories)
  for dir in directories
    call PrintLine('} // namespace ' . dir)
  endfor
  call PrintLine('')
  call PrintLine('#endif  // ' . guard_str)
endfunction

au BufNewFile *.hpp :call AddNamespaceAndHashGuard()
au BufNewFile *.h :call AddNamespaceAndHashGuard()
