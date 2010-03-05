" delete_content : delete content in region
"   if region make from between '<foo>' and '</foo>'
"   --------------------
"   begin:<foo>
"   </foo>:end
"   --------------------
"   this function make the content as following
"   --------------------
"   begin::end
"   --------------------
function! s:delete_content(lhs, rhs)
  let lines = getline(a:lhs[0], a:rhs[0])
  call setpos('.', [0, a:lhs[0], a:lhs[1], 0])
  silent! exe "delete ".(a:rhs[0] - a:lhs[0])
  call setline(line('.'), lines[0][:a:lhs[1]-2] . lines[-1][a:rhs[1]])
endfunction

" change_content : change content in region
"   if region make from between '<foo>' and '</foo>'
"   --------------------
"   begin:<foo>
"   </foo>:end
"   --------------------
"   and content is
"   --------------------
"   foo
"   bar
"   baz
"   --------------------
"   this function make the content as following
"   --------------------
"   begin:foo
"   bar
"   baz:end
"   --------------------
function! s:change_content(lhs, rhs, content)
  let oldlines = getline(a:lhs[0], a:rhs[0])
  let newlines = split(a:content, '\n')
  call setpos('.', [0, a:lhs[0], a:lhs[1], 0])
  silent! exe "delete ".(a:rhs[0] - a:lhs[0])
  if len(newlines) == 1
    call setline(line('.'), oldlines[0][:a:lhs[1]-2] . newlines[0] . oldlines[-1][a:rhs[1]])
  else
    let newlines[0] = oldlines[0][a:lhs[1]-2] . newlines[0]
    let newlines[-1] .= oldlines[-1][a:rhs[1]]
    call setline(line('.'), newlines[0])
    call append(line('.'), newlines[1:])
  endif
endfunction

" select_region : select region
"   this function make a selection of region
function! s:select_region(lhs, rhs)
  call setpos('.', [0, a:lhs[0], a:lhs[1], 0])
  normal! v
  call setpos('.', [0, a:rhs[0], a:rhs[1], 0])
endfunction

" cursor_in_region : check cursor is in the region
"   this function return 0 or 1
function! s:cursor_in_region(lhs, rhs)
  if a:lhs[0] == 0 || a:rhs[0] == 0
    return 0
  endif
  let cur = getpos('.')[1:2]
  let fpos1 = str2float(a:lhs[0].'.'.a:lhs[1])
  let fpos2 = str2float(cur[0].'.'.cur[1])
  let fpos3 = str2float(a:rhs[0].'.'.a:rhs[1])
  return fpos1 <= fpos2 && fpos2 <= fpos3
endfunction

" region_is_valid : check region is valid
"   this function return 0 or 1
function! s:region_is_valid(lhs, rhs)
  if a:lhs[0] == 0 || a:rhs[0] == 0
    return 0
  endif
  return 1
endfunction

" search_region : make region from pattern which is composing start/end 
"   this function return array of position
function! s:search_region(start, end)
  return [searchpos(a:start, 'bcnW'), searchpos(a:end, 'cneW')]
endfunction

" vim:set et:
