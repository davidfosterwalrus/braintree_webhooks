class WebhooksController < ApplicationController #:nodoc:

#Gateway configuration. Inputting API keys directly into your server-side code is largely considered
#not secure. As good practice, your API keys are saved as environmental variables in a yml file that is
#ignored from git and shielded from the pages that carry out server-side requests.

  def gateway
    Braintree::Gateway.new(
      environment: :sandbox,
      merchant_id: ENV["MERCHANT_ID"],
      public_key: ENV["PUBLIC_KEY"],
      private_key: ENV["PRIVATE_KEY"],
    )
  end

#This is the code that actually receives the webhook and parses it per our SDK's method for webhooks.
  def webhook
    webhook_notification = gateway.webhook_notification.parse(
      request.params["bt_signature"],
      request.params["bt_payload"]
    )
#This organizes the parsed parameters into an array
    webhook = Webhook.new(
      :kind => webhook_notification.kind,
      :timestamp => webhook_notification.timestamp,
      :object => webhook_notification.inspect
    )
#The array is then stored to your database. You can call this array later with a SQL query attached
#to pull data from your database and insert it in the above format into the array.
    webhook.save
#Return a 200 response if successful, and redirect back to the start of this path so other webhooks can be parsed
#as they come in.
    return 200
    redirect_to webhook_path
  end

#This code is server-side logic tied to the search function on the homepage. When a search is triggered
#by the 'Fetch New Webhook' button, the code below will run.
  def search
    @merchant_id = ENV["MERCHANT_ID"]

    filter_test = params['filterTest']
    if filter_test.nil?
      filter_test = 'null'
    end
    filter_au = params['filterAu']
    if filter_au.nil?
      filter_au = 'null'
    end
    filter_bt_auth = params['filterBtAuth']
    if filter_bt_auth.nil?
      filter_bt_auth = 'null'
    end
    filter_disbursement = params['filterDisbursement']
    if filter_disbursement.nil?
      filter_disbursement = 'null'
    end
    filter_dispute = params['filterDispute']
    if filter_dispute.nil?
      filter_dispute = 'null'
    end
    filter_grant = params['filterGrant']
    if filter_grant.nil?
      filter_grant = 'null'
    end
    filter_lpm = params['filterLpm']
    if filter_lpm.nil?
      filter_lpm = 'null'
    end
    filter_oauth = params['filterOauth']
    if filter_oauth.nil?
      filter_oauth = 'null'
    end
    filter_pm = params['filterPaymentMethod']
    if filter_pm.nil?
      filter_pm = 'null'
    end
    filter_submerch = params['filterSubmerchant']
    if filter_submerch.nil?
      filter_submerch = 'null'
    end
    filter_subscription = params['filterSubscription']
    if filter_subscription.nil?
      filter_subscription = 'null'
    end
    filter_transaction = params['filterTransaction']
    if filter_transaction.nil?
      filter_transaction = 'null'
    end

    start_date = params['startDate']
    end_date = params['endDate']
    start_time = params['startTime']
    end_time = params['endTime']
    all_unchecked = params['allunchecked']

    start_val = start_date + ' ' + start_time
    end_val = end_date + ' ' + end_time

    if all_unchecked == 'true'

      if start_date.empty? && end_date.empty?
        @webhooks = Webhook.where({created_at: (Time.now. - 1.days)..Time.now})
        .order('created_at desc')
        if @webhooks.empty?
          flash[:danger] = 'No search results'
          redirect_to root_path
        else
          render 'show.html.erb'
        end

      else
        @webhooks = Webhook.where({created_at: (start_val)..end_val})
        .order('created_at desc')
        if @webhooks.empty?
          flash[:danger] = 'No search results'
          redirect_to root_path
        else
          render 'show.html.erb'
        end

      end

    else
      if start_date.empty? && end_date.empty?
        @webhooks = Webhook.where("kind like ?", "%#{filter_test}%")
        .or(Webhook.where("kind like ?", "%#{filter_au}%")
        .or(Webhook.where("kind like ?", "%#{filter_bt_auth}%")
        .or(Webhook.where("kind like ?", "%#{filter_bt_auth}%")
        .or(Webhook.where("kind like ?", "%#{filter_disbursement}%")
        .or(Webhook.where("kind like ?", "%#{filter_dispute}%")
        .or(Webhook.where("kind like ?", "%#{filter_grant}%")
        .or(Webhook.where("kind like ?", "%#{filter_lpm}%")
        .or(Webhook.where("kind like ?", "%#{filter_oauth}%")
        .or(Webhook.where("kind like ?", "%#{filter_pm}%")
        .or(Webhook.where("kind like ?", "%#{filter_submerch}%")
        .or(Webhook.where("kind like ?", "%#{filter_subscription}%")
        .or(Webhook.where("kind like ?", "%#{filter_transaction}%")))))))))))))
        .where({created_at: (Time.now. - 1.days)..Time.now})
        .order('created_at desc')
        if @webhooks.empty?
          flash[:danger] = 'No search results'
          redirect_to root_path
        else
          render 'show.html.erb'
        end

      else
        @webhooks = Webhook.where("kind like ?", "%#{filter_test}%")
        .or(Webhook.where("kind like ?", "%#{filter_au}%")
        .or(Webhook.where("kind like ?", "%#{filter_bt_auth}%")
        .or(Webhook.where("kind like ?", "%#{filter_bt_auth}%")
        .or(Webhook.where("kind like ?", "%#{filter_disbursement}%")
        .or(Webhook.where("kind like ?", "%#{filter_dispute}%")
        .or(Webhook.where("kind like ?", "%#{filter_grant}%")
        .or(Webhook.where("kind like ?", "%#{filter_lpm}%")
        .or(Webhook.where("kind like ?", "%#{filter_oauth}%")
        .or(Webhook.where("kind like ?", "%#{filter_pm}%")
        .or(Webhook.where("kind like ?", "%#{filter_submerch}%")
        .or(Webhook.where("kind like ?", "%#{filter_subscription}%")
        .or(Webhook.where("kind like ?", "%#{filter_transaction}%")))))))))))))
        .where({created_at: (start_val)..end_val})
        .order('created_at desc')
        if @webhooks.empty?
          flash[:danger] = 'No search results'
          redirect_to root_path
        else
          render 'show.html.erb'
        end

      end
    end
  end

#Server-side logic for the default search that auto-populates on the homepage.
  def show
    @merchant_id = ENV["MERCHANT_ID"]
    @webhooks = Webhook.where({created_at: (Time.now. - 1.days)..Time.now}).order('created_at desc')
    render 'show.html.erb'
  end
end
