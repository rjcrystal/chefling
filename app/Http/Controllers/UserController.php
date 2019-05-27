<?php

namespace App\Http\Controllers;

use App\Enums\ResponseCode;
use App\Http\Resources\UserResource;
use App\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    public function profile(){
        $user = Auth::user();
        return new UserResource($user);
    }

    public function update(Request $request)
    {
        $user = Auth::user();
        $validator = Validator::make($request->all(), [
            'name' => 'string|nullable',
            'password' => 'string|nullable|min:6|max:20'
        ]);

        if ($validator->fails()) {
            return response()->json([$validator->errors()], ResponseCode::HTTP_BAD_REQUEST);
        }
        try {
            $user->name = $request->name ?? $user->name;
            if(!empty($request->password)) {
                $user->password = Hash::make($request->password);
            }
            $user->save();
            return new UserResource($user);
        }
        catch (Exception $exception)
        {
            return response()->json(['error'=>$exception->getMessage()],ResponseCode::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
}
