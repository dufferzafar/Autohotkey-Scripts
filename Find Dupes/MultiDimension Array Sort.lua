function BubbleSort(set)
	local tmp
	
	--Bubble Sort
	for i = 1, #set do
		for j = 1, #set-i do
			if ( set[j] > set[j+1] ) then
				tmp = set[j]
				set[j] = set[j+1]
				set[j+1] = tmp
			end
		end
	end

	return set
end

--
--in-place quicksort
function QuickSort(t, start, endi)
  start, endi = start or 1, endi or #t
  --partition w.r.t. first element
  if(endi - start < 2) then return t end
  local pivot = start
  for i = start + 1, endi do
    if t[i] <= t[pivot] then
      local temp = t[pivot + 1]
      t[pivot + 1] = t[pivot]
      if(i == pivot + 1) then
        t[pivot] = temp
      else
        t[pivot] = t[i]
        t[i] = temp
      end
      pivot = pivot + 1
    end
  end
  t = QuickSort(t, start, pivot - 1)
  return QuickSort(t, pivot + 1, endi)
end

function ShellSort( a )
    local inc = math.ceil( #a / 2 )
    while inc > 0 do
        for i = inc, #a do
            local tmp = a[i]
            local j = i
            while j > inc and a[j-inc] > tmp do
                a[j] = a[j-inc]
                j = j - inc
            end
            a[j] = tmp
        end
        inc = math.floor( 0.5 + inc / 2.2 )
    end 
 
    return a
end
 
--example
s = os.clock()
QuickSort{5, 2, 7, 3, 4, 7,2, 7, 3, 4, 7, 1, 98, 34,1, 98, 34, 12,5, 2, 7, 3, 4, 7,2, 7, 3, 4, 7, 1, 98, 34,1, 98, 34, 12}
-- BubbleSort{5, 2, 7, 3, 4, 7,2, 7, 3, 4, 7, 1, 98, 34,1, 98, 34, 12,5, 2, 7, 3, 4, 7,2, 7, 3, 4, 7, 1, 98, 34,1, 98, 34, 12}
-- ShellSort{5, 2, 7, 3, 4, 7,2, 7, 3, 4, 7, 1, 98, 34,1, 98, 34, 12,5, 2, 7, 3, 4, 7,2, 7, 3, 4, 7, 1, 98, 34,1, 98, 34, 12}
e = os.clock()
print(e-s)