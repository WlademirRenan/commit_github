# encoding: utf-8
require 'spec_helper'
require_relative '../interface'

describe Interface do
  before :each do
    @interface = Interface.new
  end
  it "deve retornar data e hora formatados" do
    data_hora_f = @interface.data_hora_f
    data_hora_f.should == data_hora_f
  end
end