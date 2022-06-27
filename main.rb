require './proof.rb'

suc = <<~EOS
$x[0] + 1
EOS
suc_g = encode(suc)
#後者関数のゲーデル数
#=>172225373526401451307274

add = <<~EOS
$x[0] + $x[1]
EOS
add_g = encode(add)
#足し算のゲーデル数
#=>739702346837278425917858602114314

universal(add_g,[1,2])
#=>3

add3_g = smn(1, 1, add_g, [3])
#smn定理によって構成された足す3をする関数のゲーデル数
#=>983233069263274963323824428022964059843163818637666943491722412383498
# $x[1, 1] = [3]
# $x[0] + $x[1]
# universal(add3_g,[7]) => 10

add_rec = rec(add_g, 1)
#rec(prog_g, n): n には prog の引数の最後のインデックスを指定する
d2 = universal(add_rec,[20])
d1 = universal(add_g, [20, add_rec])
d1 == d2 #=> true
#任意の帰納的関数 f に対して
#f(x,e) = universal(e, x) となるような e を計算できる

add_fix = fix(add_g,1)
diff = 8674902943253894975761493816011735850335645272865677887187684913482310061620934939375740761877886622904375259150528507409849711757013933513525946758855990082432526097941335836208395964307762145747304158130003517455943751152113619715814375486353516147783951615306319785967721759716891266799786734500425359756207876971689401265931048821943069664285320092129596888844417178199082932415841019026787598846430892653655638086730370290298973799308876149190562492770719627583972699584930907588011003129270860752303295129805319558264290566700188884688335765564352426221230699165850339668668493310557953569066748458680504788384371234321131602175364763537988612756861616668358775863864592628689798893901215641574927203444253249440610435368189509600320296946241131988252274705479340748349322301716125873525523523242760917623218108182
#diff は "2+3 ... " のゲーデル数との差分
e2 = universal(add_fix,[diff])
e1 = universal(universal(add_g,[diff,add_fix]),[diff])
e1 == e2 #=> true

id = <<~EOS
$x[0]
EOS
id_g = encode(id)
quine_seed = <<~EOS
universal(smn(0,1,#{id_g},[$x[0]]),[])
EOS
quine_seed_g = encode(quine_seed)

quine = rec(quine_seed_g, 0)
quine == universal(quine,[])
#=>true