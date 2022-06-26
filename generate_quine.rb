def encode(prog)#str -> int
  prog.unpack("H*")[0].to_i(16)
end

def decode(int)#int -> str
  [int.to_s(16)].pack("H*")
end

$x_temp = []
$x = []
$Definition = <<'DEF'
def encode(prog)
  prog.unpack("H*")[0].to_i(16)
end

def decode(int)
  [int.to_s(16)].pack("H*")
end

def universal(prog_g, inputs)
  prog = decode(prog_g)
  args = "$x = " + inputs.to_s + "\n"
  $x_temp.push($x.dup)
  $x = []
  ans = eval(args + prog)
  $x = $x_temp.shift
  return ans
end

$definitionstr = '$Definition = <<\'DEF\''+"\n"+$Definition +"DEF\n"

def smn(m, n, prog_g, inputs)
  init = "$x=[] unless $x\n" + "$x_temp=[] unless $x_temp\n"
  prog = decode(prog_g)
  args = "$x[#{m}, #{n}] = " + inputs[0, n].to_s + "\n"
  encode($definitionstr + $Definition + init + args + prog)
end

def rec(prog_g, n)
  prog = decode(prog_g)
  f = <<~EOS
  $x[#{n}] = smn(#{n}, 1, $x[#{n}], [$x[#{n}]])
  #{prog}
  EOS
  f_g = encode(f)
  smn(n, 1, f_g, [f_g])
end
DEF
$definitionstr = '$Definition = <<\'DEF\''+"\n"+$Definition +"DEF\n"

def universal(prog_g, inputs)#万能関数
  prog = decode(prog_g)
  args = "$x = " + inputs.to_s + "\n"
  $x_temp.push($x.dup)
  $x = []
  ans = eval(args + prog)
  $x = $x_temp.shift
  return ans
end

def smn(m, n, prog_g, inputs)#smn定理
  init = "$x=[] unless $x\n" + "$x_temp=[] unless $x_temp\n"
  prog = decode(prog_g)
  args = "$x[#{m}, #{n}] = " + inputs[0, n].to_s + "\n"
  encode($definitionstr + $Definition + init + args + prog)
end

def rec(prog_g, n)#再帰定理
  prog = decode(prog_g)
  f = <<~EOS
  $x[#{n}] = smn(#{n}, 1, $x[#{n}], [$x[#{n}]])
  #{prog}
  EOS
  f_g = encode(f)
  smn(n, 1, f_g, [f_g])
end

id = <<~EOS
print(decode($x[0]))
EOS
#print (decode($x[0]))
#とすると標準入出力に出力
id_g = encode(id)
quine_seed = <<~EOS
universal(smn(0,1,#{id_g},[$x[0]]),[])
EOS
quine_seed_g = encode($definitionstr + $Definition + quine_seed)

quine = decode(rec(quine_seed_g, 0))
eval(quine)
#=>true