<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('messages', function (Blueprint $table) {
            $table->id();
            $table->string('filename')->nullable();
            $table->string('doc_id')->nullable();
            $table->string('header')->nullable();
            $table->string('ref_number')->nullable();
            $table->string('msg_type')->nullable();
            $table->string('io_mode')->nullable();
            $table->string('sender_account')->nullable();
            $table->string('sender')->nullable();
            $table->decimal('tran_amount', 50, 4)->nullable();
            $table->string('acct_inst')->nullable();
            $table->string('remittance_info')->nullable();
            $table->string('beneficiary')->nullable();
            $table->string('beneficiary_acct')->nullable();
            $table->string('curr')->nullable();
            $table->string('service_id')->nullable();
            $table->string('ack')->nullable();
            $table->string('app_id')->nullable();
            $table->string('terminal_address')->nullable();
            $table->string('session_number')->nullable();
            $table->string('sequence_number')->nullable();
            $table->string('tran_timestamp')->nullable();
            $table->date('tran_date')->nullable();
            $table->string('recipient_bic')->nullable();
            $table->string('msg_priority')->nullable();
            $table->string('msg_user_preference')->nullable();
            $table->string('bank_priority_code')->nullable();
            $table->string('aok')->nullable();
            $table->longText('message_text')->nullable();
            $table->timestamp('created_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamp('updated_at')->default(DB::raw('CURRENT_TIMESTAMP'));

            // Indexes
            $table->index('tran_date');
            $table->index('curr');
            $table->index('io_mode');
            $table->index('msg_type');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('messages');
    }
};
