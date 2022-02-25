<?php

namespace App\Http\Controllers;

use Illuminate\Contracts\View\View;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    /**
     * @param Request $request
     * @return View
     */
    public function index(Request $request) : View
    {
        return view('welcome');
    }
}
