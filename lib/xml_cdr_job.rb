# Copyright (C) 2012 Bit4Bit <bit4bit@riseup.net>
#
#
# This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'uri'
require 'zlib'
require 'csv'

class XmlCdrJob
  attr_accessor  :xml_cdr, :prefix_dir
  def initialize(xml_cdr, prefix_dir ='')
    self.xml_cdr = xml_cdr
    self.prefix_dir = prefix_dir
  end
  
  def perform
    case self.xml_cdr
    when String
      cdr = (Hash.from_xml self.xml_cdr)['cdr']
    when Hash
      cdr = self.xml_cdr['cdr']
    end
    
    Rails.logger.debug(cdr)
    nibble_account = URI.decode(cdr['variables']['nibble_account'])
    create_directories(nibble_account, cdr)
    
    cdr_day(nibble_account, cdr)
    cdr_week(nibble_account, cdr)
    cdr_month(nibble_account, cdr)
  end

  private
  def create_directories(account, cdr)
    begin Dir.mkdir(Rails.root.join(cdr_dir)) ;rescue; end
    begin Dir.mkdir(Rails.root.join(cdr_dir, account)) ;rescue; end
    begin Dir.mkdir(Rails.root.join(cdr_dir, account, time_cdr(cdr).to_s(:cdr_month))) ;rescue; end
  end
  
  def time_cdr(cdr)
    Time.at(URI.decode(cdr['variables']['start_epoch']).to_d)
  end
  
  def cdr_to_save(account, cdr)
    {
      :account_id => account.to_i,
      :signaling_ip => URI.decode(cdr['variables']['sip_network_ip']),
      :remote_media_ip => URI.decode(cdr['variables']['remote_media_ip']),
      :call_time => Time.at(URI.decode(cdr['variables']['start_epoch']).to_d).to_s,
      :duration => URI.decode(cdr['variables']['billsec']).to_i,
      :destination_number => URI.decode(cdr['callflow']['caller_profile']['destination_number']),
      :ani => URI.decode(cdr['callflow']['caller_profile']['ani']),
      :total_amount => calculate_total_amount(cdr)
    }
  end

  def cdr_dir
    self.prefix_dir.to_s + 'cdr'
  end
  
  def cdr_save(account, cdr, cdr_file)
    create_header(cdr_file, cdr_to_save(account, cdr).keys)
    gz = Zlib::GzipWriter.new(File.open(cdr_file, 'ab'))
    gz.write CSV.generate_line(cdr_to_save(account, cdr).values)
    gz.close
  end
  
  def calculate_total_amount(cdr)
    cash_plan = PublicCashPlan.find(cdr['variables']['simplecos_cash_plan'].to_i)
    (cash_plan.bill_rate * cdr['variables']['billsec'].to_d) / 60 #@todo el cobro donde esta la unidad de cobro??
  end
  
  def create_header(cdr_file, header)
    if not File.exists?(cdr_file)
      gz = Zlib::GzipWriter.new(File.open(cdr_file, 'wb'))
      gz.write CSV.generate_line(header)
      gz.close
    end
  end
  
  def cdr_day(account, cdr)
    cdr_file = Rails.root.join(cdr_dir, account.to_s, time_cdr(cdr).to_s(:cdr_month), 'day_' + time_cdr(cdr).strftime("%d") + ".csv.gz" )
   cdr_save(account, cdr, cdr_file)
  end
  
  def cdr_month(account, cdr)
    cdr_file = Rails.root.join(cdr_dir, account.to_s, time_cdr(cdr).to_s(:cdr_month), 'month_' + time_cdr(cdr).to_s(:cdr_month) + '.csv.gz')
    cdr_save(account, cdr, cdr_file)
  end
  
  def cdr_week(account, cdr)
    cdr_file = Rails.root.join(cdr_dir, account.to_s, time_cdr(cdr).to_s(:cdr_month), 'week_' + time_cdr(cdr).to_s(:cdr_week) + '.csv.gz')
    cdr_save(account, cdr, cdr_file)
  end
  
  
  
end
