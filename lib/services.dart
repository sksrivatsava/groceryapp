String getUser(str){

  var idx=str.indexOf('@');
//   print(idx);
  String str2=str.substring(0,idx);
//   print(str2);
  return str2;
}