<?php

namespace App\Http\Controllers;

use App\Enums\ResponseCode;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use League\OAuth2\Server\Exception\OAuthServerException;


class AuthController extends Controller
{
    public function login(Request $request){

        $validator = Validator::make($request->all(),[
            'email'=>'string|required|email',
            'password'=>'string|required|min:6|max:20'
        ]);

        if($validator->fails()) {
            return response()->json(['error'=>$validator->errors()],ResponseCode::HTTP_BAD_REQUEST);
        }

        $user = User::where('email',$request->email)->first();

        if(!empty($user)){
            if(Hash::check($request->password,$user->password)) {
                $accessToken = $user->getBearerTokenByUser(false);
                return response()->json($accessToken);
            }
            else{
                return response()->json(['error'=>"Email/Password is incorrect"],ResponseCode::HTTP_UNAUTHORIZED);
            }
        }
        else {
            return response()->json(['error'=>"Email/Password is incorrect"],ResponseCode::HTTP_UNAUTHORIZED);
        }

    }

    public function register(Request $request){

        $validator = Validator::make($request->all(),[
            'name'=>'string|required',
            'email'=>'string|required|email|unique:users,email',
            'password'=>'string|required|min:6|max:20'
        ]);

        if($validator->fails()) {
            return response()->json(['error'=>$validator->errors()],ResponseCode::HTTP_BAD_REQUEST);
        }
        try{
            $user = new User();
            $user->name = $request->name;
            $user->email = $request->email;
            $user->password = Hash::make($request->password);
            if($user->save()) {
                $accessToken = $user->getBearerTokenByUser(false);
                logger($accessToken);
                return response()->json($accessToken);
            }
            else{
                return response()->json(['error'=>"Could not create user"],ResponseCode::HTTP_INTERNAL_SERVER_ERROR);
            }
        }
        catch (OAuthServerException $exception)
        {
            logger($exception->getMessage());
            return response()->json(['error'=>$exception->getMessage(),'code'=>$exception->getCode()],ResponseCode::HTTP_BAD_REQUEST);
        }


    }
}
