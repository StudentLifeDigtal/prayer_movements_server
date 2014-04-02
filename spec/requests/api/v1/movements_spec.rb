# spec/requests/api/v1/movements_spec.rb
require "spec_helper"

describe "api/v1/movements.json" do
	let(:auth) { authenticate }

	describe "#get" do
		context "when no movements are found" do
			it "respond with empty array" do
	    	get "/api/v1/movements.json", {"access_token" => auth[:token]}
	    	expect(response).to be_success
	    	expect(json.length).to eq(0)
			end
		end

		context "when 10 movements are found" do
			it "respond with an array" do
				FactoryGirl.create_list(:movement, 10)
	    	get "/api/v1/movements.json", {"access_token" => auth[:token]}
	    	expect(response).to be_success
	    	expect(json.length).to eq(10)
	    end
	  end

	  context "when too many movements are found" do
	  	it "paginates movements in an array (max size of ten)" do
				FactoryGirl.create_list(:movement, 11)
	    	get "/api/v1/movements.json", {"access_token" => auth[:token]}
	    	expect(response).to be_success
  			expect(response.headers["X-Per-Page"].to_i ).to eq(10)
	  	end
	  	it "paginates the array" do
				FactoryGirl.create_list(:movement, 11)
	    	get "/api/v1/movements.json", {"access_token" => auth[:token]}
	    	expect(response).to be_success
  			expect((response.headers.keys & ["X-Total:","X-Total-Pages","X-Page","X-Per-Page"]).all?).to be_true
  			expect(response.headers["X-Total-Pages"].to_i ).to eq(2)
  		end

  		it "allows us to specify movements per page" do
				FactoryGirl.create_list(:movement, 10)
	    	get "/api/v1/movements.json", {"access_token" => auth[:token], "per_page" => 2}
	    	expect(response).to be_success
  			expect((response.headers.keys & ["X-Total:","X-Total-Pages","X-Page","X-Per-Page"]).all?).to be_true
  			expect(response.headers["X-Total-Pages"].to_i ).to eq(5)
  		end

  		it "allows us to navigates pages of movements" do
				FactoryGirl.create_list(:movement, 11)
	    	get "/api/v1/movements.json", {"access_token" => auth[:token], "page" => 2}
	    	expect(response).to be_success
  			expect((response.headers.keys & ["X-Total:","X-Total-Pages","X-Page","X-Per-Page"]).all?).to be_true
  			expect(json.length).to eq(1)
  		end
  	end

  	context "when no open movements are found" do
	  	it "respond with empty array" do
  			FactoryGirl.create(:movement, privacy: "closed")
  			FactoryGirl.create(:movement, privacy: "secret")
	    	get "/api/v1/movements.json", {"access_token" => auth[:token]}
	    	expect(response).to be_success
	    	expect(json.length).to eq(0)
	    end
  	end

  	context "when open movements are found" do
	  	it "respond with an array" do
  			FactoryGirl.create(:movement, privacy: "closed")
  			FactoryGirl.create(:movement, privacy: "secret")
  			FactoryGirl.create(:movement)
	    	get "/api/v1/movements.json", {"access_token" => auth[:token]}
	    	expect(response).to be_success
	    	expect(json.length).to eq(1)
	    end
  	end

  	context "when user is a member of private movements" do
  		it "respond with an array" do
  			FactoryGirl.create(:movement, privacy: "secret", users: [ auth[:user] ])
  			FactoryGirl.create(:movement, privacy: "closed", users: [ auth[:user] ])
  			FactoryGirl.create(:movement, privacy: "secret")
  			FactoryGirl.create(:movement)
	    	get "/api/v1/movements.json", {"access_token" => auth[:token]}
	    	expect(response).to be_success
	    	expect(json.length).to eq(3)
  		end
  	end

  	context "when user is banned from private or closed movements" do
  		it "respond with an array without banned movement" do
  			FactoryGirl.create(:movement)
  			movement = FactoryGirl.create(:movement, privacy: "closed", users: [ auth[:user] ])
  			membership = movement.memberships.first
  			membership.role = "banned"
  			membership.save
	    	get "/api/v1/movements.json", {"access_token" => auth[:token]}
	    	expect(response).to be_success
	    	expect(json.length).to eq(1)
  		end
  	end
	end
end

describe "api/v1/movements/:id.json" do
	let(:auth) { authenticate }

	describe "#get" do 
		context "when no movement is found" do
			it "respond with 404" do
				get "/api/v1/movements/0.json", {"access_token" => auth[:token]}
	    	expect(response.status).to eq(404)
	    	expect(json["error"]).to eq("Couldn't find Movement with id=0")
			end
		end

		context "when one movement is illegally accessed" do
			it "respond with 404" do
				movement = FactoryGirl.create(:movement, privacy: "closed")
				get "/api/v1/movements/#{movement.id}.json", {"access_token" => auth[:token]}
	    	expect(response.status).to eq(404)
	    	expect(json["error"]).to eq("Couldn't find Movement with id=#{movement.id}")
			end
		end

		context "when one movement is accessed under ban" do
			it "respond with 404" do
				
  			movement = FactoryGirl.create(:movement, privacy: "closed", users: [ auth[:user] ])
  			membership = movement.memberships.first
  			membership.role = "banned"
  			membership.save
				get "/api/v1/movements/#{movement.id}.json", {"access_token" => auth[:token]}
	    	expect(response.status).to eq(404)
	    	expect(json["error"]).to eq("Couldn't find Movement with id=#{movement.id}")
			end
		end

		context "when one open movement is found" do
			it "respond with object" do
				movement = FactoryGirl.create(:movement)
				get "/api/v1/movements/#{movement.id}.json", {"access_token" => auth[:token]}
	    	expect(response).to be_success
	    end
		end

		context "when invalid id is provided" do
			it "respond with an error" do
				get "/api/v1/movements/ejkjndsf.json", {"access_token" => auth[:token]}
	    	expect(response.status).to eq(400)
	    	expect(json["error"]).to eq("id is invalid")
			end
		end

		context "when invalid type is provided" do
			it "respond with an error" do
				get "/api/v1/movements/1.json", {"access_token" => auth[:token], 'type' => 'dgkjnfgdkdjfgn'}
	    	expect(response.status).to eq(400)
	    	expect(json["error"]).to eq("type does not have a valid value")
			end
		end

		context "when invalid id and type is provided" do
			it "respond with an error" do
				get "/api/v1/movements/kjnfdg.json", {"access_token" => auth[:token], 'type' => 'dgkjnfgdkdjfgn'}
	    	expect(response.status).to eq(400)
	    	expect(json["error"]).to eq("id is invalid, type does not have a valid value")
			end
		end


	end
end
