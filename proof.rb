require 'base64'
def universal(gedel,input)
  prog = Base64.decode64(gedel)
  ans = eval(input + prog)
  return ans
end

def smn(m, gedel, inputs)
  prog = Base64.decode64(gedel)
  inputs.each_with_index.reverse_each do |x,i|
    prog = "x#{m+i+1}=#{x}" + prog
  end
  return Base64.strict_encode(prog)
end

def f(ary, z)
  
end

def fix()
  hoge
end


def h(x,y)
  return universal(universal(y,x),'')
end
