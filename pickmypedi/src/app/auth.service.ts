import { Auth } from 'aws-amplify';
import { AmplifyService } from 'aws-amplify-angular';
import { Injectable } from '@angular/core';

@Injectable()
export class AuthService {
    constructor(
      private amplify: AmplifyService,
    ) {}

    authState: string;

    init() {
    this.amplify.authStateChange$.subscribe(authState=> {
        this.authState = authState.state;
    })
}

    login(username: string, password: string){
        Auth.signIn(username,password)
        .catch(err => console.log(err))
    }

    createAccount(
        username: string,
        password: string,
        email: string,
        firstName: string,
        lastName: string,
        phoneNumber: string,
        birthDate: string,

    ){
        Auth.signUp({
            username: username,
            password: password,
            attributes:{
                email: email,
                phoneNumber: phoneNumber,
                firstName: firstName,
                lastName: lastName,
                birthDate: birthDate
            },
            validationData: []
        })
    }
}