require 'spec_helper'

describe Stackup::Stack do
  let(:stack) { Stackup::Stack.new('stack_name', double(String)) }
  let(:cf_stack) { double(Aws::CloudFormation::Stack) }
  let(:cf) {double(Aws::CloudFormation)}

  before do
    allow(Aws::CloudFormation).to receive(:new).and_return(cf)
    allow(cf).to receive(:stacks).and_return({'stack_name' => cf_stack})
  end

  context 'validate' do
    it 'should be valid if cf validate say so' do
      allow(cf).to receive(:validate_template).and_return({})
      expect(stack.valid?).to be true
    end

    it 'should be invalid if cf validate say so' do
      allow(cf).to receive(:validate_template).and_return({code: '404'})
      expect(stack.valid?).to be false
    end

  end

  context 'deployed' do
    it 'should be true if it is already deployed' do
      allow(cf_stack).to receive(:exists?).and_return(true)
      expect(stack.deployed?).to be true
    end

    it 'should be false if it is not deployed' do
      allow(cf_stack).to receive(:exists?).and_return(false)
      expect(stack.deployed?).to be false
    end
  end
end
