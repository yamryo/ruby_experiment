#
# spec/Letter_spec.rb
#
# Time-stamp: <2017-03-03 18:29:03 (ryosuke)>
require('spec_helper')

require('Letter.rb')

describe Letter do
  let(:gen) { Letter.new(letter) }
  let(:gen_i) { Letter.new(letter, name: name) }
  #---------------------------------------
  describe 'Constants' do
  end
  #---------------------------------------

  #---------------------------------------
  describe '#initialize' do
    describe "with a single letter 'g'" do
      let(:letter) { 'g' }
      context '@letter' do
        it { expect(gen.char).to eq letter }
      end
      context '@index' do
        it { expect(gen.show).to eq letter }
      end
      context '@inverse?' do
        it { expect(gen.inverse?).to be_falsy }
      end
    end
    #
    describe "with a single upcase letter 'A'" do
      let(:letter) { 'A' }
      context '@letter' do
        it { expect(gen.char).to eq letter }
      end
      context '@inverse?' do
        it { expect(gen.inverse?).to be_truthy }
      end
    end
    #
    describe "with bad letters '&','2' and ' '(space)" do
      ['&', '2', ' '].each do |c|
        it { expect { Letter.new(c) }.to raise_error(Element::InvalidArgument) }
      end
    end
    #
    context 'with no argument' do
      it { expect(Letter.new.to_s).to eq '1' }
    end
    #-----
    context 'with a name' do
      let(:letter) { 'g' }
      let(:name) { 'g_{3}' }
      it { expect(gen_i.show).to eq name }
    end
    #
  end
  #---------------------------------------

  #---------------------------------------
  describe 'comparisons' do
    let(:gen) { Letter.new('z') }
    let(:gen1) { Letter.new('x', name: 'x_{3}') }
    let(:gen2) { Letter.new('X', name: 'x_{3}^{-1}') }
    let(:gen3) { Letter.new('y', name: 'y') }
    #
    context '=~, the lax conparison,' do
      it 'returns true iff their characters coinside' do
        expect(gen =~ gen1).to be_falsy
        expect(gen1 =~ gen1.dup).to be_truthy
        expect(gen1 =~ gen2).to be_truthy
        expect(gen1 =~ gen3).to be_falsy
      end
    end
    #
    context '==, the normal comparison,' do
      it 'returns true iff their characters and inverseness coinside' do
        expect(gen == gen1).to be_falsy
        expect(gen1 == gen1.dup).to be_truthy
        expect(gen1 == gen2).to be_falsy
        expect(gen1 == gen3).to be_falsy
      end
    end
    #
    context '===, the strict comparison,' do
      it 'returns true iff the two objects exactly the same instance' do
        expect(gen === gen1).to be_falsy
        expect(gen1 === gen1.dup).to be_falsy
        expect(gen1 === gen2).to be_falsy
        expect(gen1 === gen3).to be_falsy
      end
    end
    #
  end
  #---------------------------------------

  #---------------------------------------
  describe '#inverse?' do
    context 'for a downcase letter' do
      let(:letter) { 'a' }
      subject { gen }
      it { is_expected.not_to be_inverse }
    end
    #
    context 'for an uppercase letter' do
      let(:letter) { 'A' }
      let(:idx) { 2 }
      subject { gen_i }
      it { is_expected.to be_inverse }
    end
    #
    context 'for the identity' do
      subject { Letter::Identity }
      it { is_expected.not_to be_inverse }
    end
  end
  #---------------------------------------

  #---------------------------------------
  describe '#inversion!' do
    let(:letter) { 'g' }
    let(:idx) { 4 }
    context 'for a normal Letter' do
      it 'should change inverseness' do
        [gen, gen_i].each do |g|
          expect { g.inversion! }.to change { g.inverse? }.from(false).to(true)
        end
      end
      #
      it 'make its character upcase' do
        [gen, gen_i].each do |g|
          expect(g.inversion!.to_char).to match(/[A-Z]/)
        end
      end
      #
    end
    context 'for the indentity' do
      let(:identity) { Letter.new }
      it "does not change anything of '1'" do
        expect { identity.inversion! }.not_to change { identity }
      end
    end
  end
  #---------------------------------------

  #---------------------------------------
  describe '#* (product!)' do
    let(:letter) { 'g' }
    let(:idx) { 5 }
    let(:id) { Letter::Identity }
    #---
    context 'of two normal Letters' do
      let(:other) { Letter.new('K') }
      it { [gen, gen_i].each { |g| expect(g * other).to eq [other] } }
    end
    #
    context "of a Genarator and the identity '1'" do
      it do
        [gen, gen_i].each do |g|
          expect { g * id }.not_to change { g }
          expect { id * g }.not_to change { g }
        end
      end
    end
    #---
    context 'of a Letters with its inverse' do
      it { [gen, gen_i].each { |g| expect(g * (g.dup.inversion!)).to eq id } }
    end
  end
end

#-------------
# End of File
#-------------
