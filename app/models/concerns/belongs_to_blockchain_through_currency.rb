# encoding: UTF-8
# frozen_string_literal: true

module BelongsToBlockchainThroughCurrency
  extend ActiveSupport::Concern
  belongs_to :blockchain, through: :currency

  def transaction_url
    if txid? && currency.explorer_transaction.present?
      currency.explorer_transaction.gsub('#{txid}', txid)
    end
  end

  def wallet_url
    if currency.explorer_address.present?
      currency.explorer_address.gsub('#{address}', rid)
    end
  end

  def latest_block_number
    blockchain_api.latest_block_number
  end

  def confirmations
    return 0 if block_number.blank?
    return latest_block_number - block_number if (latest_block_number - block_number) >= 0
    'N/A'
  rescue Faraday::ConnectionFailed => e
    report_exception(e)
    'N/A'
  end
end
