<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromArray;

class MessagesExport implements FromArray
{
    protected $messages;

    public function __construct(array $messages)
    {
        $this->messages = $messages;
    }

    public function array(): array
    {
        return $this->messages;
    }
}
