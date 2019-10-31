import 'package:ntlm/ntlm.dart';

 class NTLM {

   static NTLMClient initializeNTLM(String username, String password){

    NTLMClient client = new NTLMClient(
      domain: "",
      workstation: "",
      username: username,
      password: password,
    );
    return client;
  }

}


