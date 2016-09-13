-module(main).
-export([hello_world/0,card_classifier/0,test/0]).

% https://github.com/everydayhero/creditcard-test

hello_world() ->
  % Bla = string:left("Hello",2),
  % io:fwrite(Bla, []),
  CardClassifier = spawn(main, card_classifier, []),
  process_input(CardClassifier).

test() ->
  S = "1 2 3",
  SS = string:tokens(S, " "),
  io:fwrite("~s~n", [SS]).

process_next_line(File, CardClassifier) ->
  case file:read_line(File) of
    {ok, Data} ->
      CardClassifier ! {
        trim_whitespace(Data)
      },
      io:fwrite(".", []),
      process_next_line(File, CardClassifier); % loop
    {error, _} -> true;
    eof -> []
  end.

trim_whitespace(Text) ->
  re:replace(Text, "\\s+", "", [global,{return,list}]).

process_input(CardClassifier) ->
  {ok, File} = file:open("input", [raw, read, read_ahead]),
  process_next_line(File, CardClassifier).

card_classifier() -> 
  receive
    {CardNumber} -> 
      % io:fwrite("Hello World~n", []);
      io:fwrite("~s ~s ~s~n", [
        CardNumber,
        card_type(CardNumber),
        luhn_validity_text(
          luhn_validity(CardNumber)
        )
      ]),
      card_classifier();
    stop ->
      true
  end.

card_type(Num) when erlang:length(Num) == 15 -> "AMEX";
card_type(Num) when erlang:length(Num) == 13 -> "VISA";
% card_type(Num) when erlang:length(Num) == 16 and string:left(Num,1) == "4" -> "Visa";
% card_type(Num) when erlang:length(Num) == 16 ->
%     case Signal of
%         {signal, _What, _From, _To} ->
%             true;
%         {signal, _What, _To} ->
%             true;
%         _Else ->
%             false
%     end.
% 
%   if
%     string:left(Num,4) == "6011" ->
%       "Discover";
%     string:left(Num,2) == "51" ->
%       "MasterCard";
%     string:left(Num,2) == "52" ->
%       "MasterCard";
%     string:left(Num,2) == "53" ->
%       "MasterCard";
%     string:left(Num,2) == "54" ->
%       "MasterCard";
%     string:left(Num,2) == "55" ->
%       "MasterCard";
%     string:left(Num,1) == "4" ->
%       "Visa";
%     true ->
%       "Unknown"
%   end
%   % Bla = string:left("Hello",2),
%   % io:fwrite(Bla, []),
% ;
card_type(CardNumber) -> "Unknown".

luhn_validity_text(Todo) -> "valid".
% luhn_validity_text(0) -> "valid".
% luhn_validity_text(Valid) when Valid == true -> "valid".
% luhn_validity_text(Valid) -> "invalid".

luhn_validity(CardNumber) ->
  true.
