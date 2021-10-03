-module(bottom).
-license("WTFPL").
-author("portasynthinca3")

-export([encode/1, decode/1]).

encode(<<Text/binary>>) -> encode(Text, <<"">>).
encode(<<"">>, Acc) -> Acc;
encode(<<Next/unsigned, Text/binary>>, Acc) -> encode(Text, <<Acc/binary, (encode_char(Next))/binary, "👉👈"/utf8>>).

encode_char(0) -> <<"❤️">>;
encode_char(Char) -> encode_char(<<"">>, Char).
encode_char(Acc, Rem) when Rem >= 200 -> encode_char(<<Acc/binary, "🫂"/utf8>>, Rem - 200);
encode_char(Acc, Rem) when Rem >= 50 -> encode_char(<<Acc/binary, "💖"/utf8>>, Rem - 50);
encode_char(Acc, Rem) when Rem >= 10 -> encode_char(<<Acc/binary, "✨"/utf8>>, Rem - 10);
encode_char(Acc, Rem) when Rem >= 5 -> encode_char(<<Acc/binary, "🥺"/utf8>>, Rem - 5);
encode_char(Acc, Rem) when Rem >= 1 -> encode_char(<<Acc/binary, ","/utf8>>, Rem - 1);
encode_char(Acc, Rem) when Rem =< 0 -> Acc.

decode(<<Text/binary>>) -> decode(unicode:characters_to_list(Text), <<"">>, 0).
decode([], Acc, _) -> Acc;
decode([$🫂 | Text], Acc, Cp) -> decode(Text, Acc, Cp + 200);
decode([$💖 | Text], Acc, Cp) -> decode(Text, Acc, Cp + 50);
decode([$✨ | Text], Acc, Cp) -> decode(Text, Acc, Cp + 10);
decode([$🥺 | Text], Acc, Cp) -> decode(Text, Acc, Cp + 5);
decode([$, | Text], Acc, Cp) -> decode(Text, Acc, Cp + 1);
decode([16#2764 | Text], Acc, Cp) -> decode(Text, Acc, Cp);
decode([$👉, $👈 | Text], Acc, Cp) -> decode(Text, <<Acc/binary, Cp>>, 0).