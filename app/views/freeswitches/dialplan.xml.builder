xml.instruct! :xml, :version => '1.0'
xml.document :type => 'freeswitch/xml' do
  xml.section :name => 'dialplan', :description => 'Dialplan SimpleCOS' do
    xml.context :name => 'public' do
      xml.extension :name => 'limit_exceeded' do
        xml.condition :field => 'destination_number', :expression => '^limit_exceeded$' do
          xml.action :application => 'playback', :data => 'overthelimit.wav'
          xml.action :application => 'hangup'
        end
      end
      
      xml.extension :name => 'limit', :continue => true do
        xml.condition do
          xml.action :application => 'limit', :data => 'db $${domain} ${caller_id_number} ${user_data(${caller_id_number}@${domain_name} var max_calls)'
        end
      end
      
      xml.extension :name => 'hangup' do
        xml.condition :field => 'destination_number', :expression => '^(hangup)$' do
          xml.action :application => 'playback', :data => 'no_more_funds.wav'
          xml.action :application => 'hangup'
        end
      end
      
    
      #cliente, tarificacion personalizada
      #@todo ocurre error cuando hay varios clientes con el mismo nombre
      stop_public_cash_plan = false
      if Client.where(:name => params['Caller-Username']).exists?
        #se fuerza, el cuelge en caso de no tener fondos
        #aunque esto se deberia realizar desde *nibblebill_curl*
        if Client.where(:name => params['Caller-Username']).first.total_amount < 1
          stop_public_cash_plan = true
          xml.extension :name => 'hangup_not_fonds' do
            xml.condition :field => 'destination_number', :expression => '^(.+)$', :break => 'always' do
              xml.action :application => 'playback', :data => 'no_more_funds.wav'
              xml.action :application => 'hangup'
            end
          end
        end
        
        clients = Client.where(:name => params['Caller-Username'])
        ClientCashPlan.where(:client_id => clients).all.each do |client_cash_plan|
          stop_public_cash_plan = true
          xml.extension :name => 'simplecos_%d_client' % client_cash_plan.public_carrier_id do
            xml.condition :field => 'destination_number', :expression => client_cash_plan.expression do
              #no se usa pero se envia por si algo
              xml.action :application => 'set', :data => "simplecos_client_cash_plan=#{client_cash_plan.id}"
              xml.action :application => 'set', :data => "nibble_rate=#{client_cash_plan.bill_rate}"
              xml.action :application => 'set', :data => 'nibble_account=${user_data(${caller_id_number}@${domain_name} var nibble_account)}'

              if client_cash_plan.bill_minimum > 0
                xml.action :application => 'set', :data => "nibble_increment=#{client_cash_plan.bill_minimum}"
              end

              if not client_cash_plan.bridge.empty?
                xml.action :application => 'bridge', :data => client_cash_plan.bridge
              else
                xml.action :application => 'bridge', :data => "sofia/gateway/#{client_cash_plan.public_carrier.name}/$1"
              end
            end
          end
        end

      end
      
  xml.extension :name => 'test' do
        xml.condition :field => 'destination_number', :expression => '8888' do
          xml.action :application => 'set', :data => "simplecos_cash_plan=%d" % PublicCashPlan.first.id
          xml.action :application => 'set', :data => 'nibble_bill_rate=10'
          xml.action :application => 'set', :data => 'nibble_account=${user_data(${caller_id_number}@${domain_name} var nibble_account)}'
          xml.action :application => 'answer'
          xml.action :application => 'phrase', :data => 'msgcount,10'
          xml.action :application => 'hangup'
        end
      end
      
      @freeswitch.public_carriers.each{|carrier|
        break if stop_public_cash_plan
        carrier.public_cash_plans.each{|cash_plan|
          xml.extension :name => 'simplecos_%d' % cash_plan.id do
            xml.condition :field => 'destination_number', :expression => cash_plan.expression do
              #no se usa pero se envia por si algo
              xml.action :application => 'set', :data => "simplecos_cash_plan=#{cash_plan.id}"
              xml.action :application => 'set', :data => "nibble_rate=#{cash_plan.bill_rate}"
              xml.action :application => 'set', :data => 'nibble_account=${user_data(${caller_id_number}@${domain_name} var nibble_account)}'
              if cash_plan.bill_minimum > 0
                xml.action :application => 'set', :data => "nibble_increment=#{cash_plan.bill_minimum}"
              end

              if not cash_plan.bridge.empty?
                xml.action :application => 'bridge', :data => cash_plan.bridge
              else
                xml.action :application => 'bridge', :data => "sofia/gateway/#{carrier.name}/$1"
              end
            end
        end
        }
      }
    end
  end
end
