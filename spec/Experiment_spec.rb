#
# Experiment_spec.rb
#
# Time-stamp: <2017-02-23 17:37:24 (ryosuke)>
require('spec_helper')

require('Experiment.rb')

describe Letter do
  let(:gen) { Letter.new(letter) }
  let(:gen_i) { Letter.new(letter, name: name) }
  #---------------------------------------
  describe "Constants" do
  end
  #---------------------------------------

  #---------------------------------------
  describe "#initialize" do
    describe "with a single letter 'g'" do
      let(:letter){ 'g' }
      context "@letter" do
        it{ expect(gen.char).to eq letter }
      end
      context "@index" do
        it{ expect(gen.show).to eq letter }
      end
      context "@inverse?" do
        it{ expect(gen.inverse?).to be_falsy }
      end
    end
    #
    describe "with a single upcase letter 'A'" do
      let(:letter){ 'A' }
      context "@letter" do
        it{ expect(gen.char).to eq letter }
      end
      context "@inverse?" do
        it{ expect(gen.inverse?).to be_truthy }
      end
    end
    #
    describe "with bad letters '&','2' and ' '(space)" do
      ['&','2',' '].each do |c|
        it { expect{ Letter.new(c) }.to raise_error(Element::InvalidArgument) }
      end
    end
    #
    context "with no argument" do
      it{ expect(Letter.new.to_s).to eq '1' }
    end
    #-----
    context "with a name" do
      let(:letter){ 'g' }
      let(:name){ 'g_{3}' }
      it{ expect(gen_i.show).to eq name }
    end
    #
  end
  #---------------------------------------

  #---------------------------------------
  describe "comparisons" do
    let(:gen){ Letter.new('z') }
    let(:gen1){ Letter.new('x', name: 'x_{3}') }
    let(:gen2){ Letter.new('X', name: 'x_{3}^{-1}') }
    let(:gen3){ Letter.new('y', name: 'y') }
    #
    context "=~, the lax conparison," do
      it "should return true iff the letters and indecies coinside" do
        expect(gen =~ gen1).to be_falsy
        expect(gen1 =~ gen1.dup).to be_truthy
        expect(gen1 =~ gen2).to be_falsy
        expect(gen1 =~ gen3).to be_falsy
      end
    end
    #
    context "==, the normal comparison," do
      it "should return true iff the letters and inverseness coinside" do
        expect(gen == gen_i).to be_falsy
        expect(gen == gen.dup.inversion!).to be_falsy
        expect(gen_i == gen1).to be_truthy
        expect(gen_i == gen2).to be_falsy
        expect(gen_i == gen3).to be_falsy
        expect(gen_i == gen4).to be_falsy
        expect(gen_i == gen5).to be_falsy
        expect(gen_i == gen6).to be_falsy
        expect(gen_i == gen7).to be_falsy
        expect(gen_i == gen8).to be_falsy
      end
    end
    #
    context "===, the strict comparison," do
      it "should return true iff the two objects exactly the same instance" do
        expect(gen === gen_i).to be_falsy
        expect(gen === gen.dup.inversion!).to be_falsy
        expect(gen_i === gen1).to be_falsy
        expect(gen_i === gen2).to be_falsy
        expect(gen_i === gen3).to be_falsy
        expect(gen_i === gen4).to be_falsy
        expect(gen_i === gen5).to be_falsy
        expect(gen_i === gen6).to be_falsy
        expect(gen_i === gen7).to be_falsy
        expect(gen_i === gen8).to be_falsy
      end
    end
    #
  end
  #---------------------------------------

  #---------------------------------------
  describe "#inverse?" do
    context 'for a downcase letter' do
      let(:letter) { 'a' }
      subject{ gen }
      it{ is_expected.not_to be_inverse }
    end
    #
    context 'for an uppercase letter' do
      let(:letter) { 'A' }
      let(:idx) { 2 }
      subject{ gen_i }
      it{ is_expected.to be_inverse }
    end
    #
    context 'for the identity' do
      subject{ Letter::Identity }
      it{ is_expected.not_to be_inverse }
    end
  end
  #---------------------------------------

  #---------------------------------------
  describe "#inversion!" do
    let(:letter) { 'g' }
    let(:idx) { 4 }
    context "for a normal Letter" do
      it "should change inverseness" do
        expect{ gen.inversion! }.to change{ gen.inverse? }.from(false).to(true)
        expect{ gen_i.inversion! }.to change{ gen_i.inverse? }.from(false).to(true)
      end
      #
      it "make its character upcase" do
        expect(gen.inversion!.to_char).to match /[A-Z]/
        expect(gen_i.inversion!.to_char).to match /[A-Z]/
      end
      #
    end
    context "for the indentity" do
      let(:identity) { Letter.new }
      it "does not change anything of '1'" do
        expect{ identity.inversion! }.not_to change{ identity }
      end
    end
    #
  end
  #---------------------------------------

  #---------------------------------------
  describe "#* (product!)" do
    let(:letter) { 'g' }
    let(:idx){ 5 }
    let(:id) { Letter::Identity }
    #---
    context "of two normal Letters" do
      let(:another) { Letter.new('K')}
      it { expect(gen*another).to eq [gen, another]}
      it { expect(gen_i*another).to eq [gen_i, another]}
    end
    #
    context "of a Genarator and the identity '1'" do
      it {
        expect{ gen*id }.not_to change{ gen }
        expect{ id*gen }.not_to change{ gen }
      }
      it {
        expect{ gen_i*id }.not_to change{ gen }
        expect{ id*gen_i }.not_to change{ gen }
      }
    end
    #---
    context "of a Letters with its inverse" do
      it { expect(gen*(gen.dup.inversion!)).to eq id
        expect(gen_i*(gen_i.dup.inversion!)).to eq id
      }
    end
    #
  end
  #---------------------------------------

end

describe Word do
  #--------------------------------------------------
  describe "Constants" do
    context "Identity" do
      subject { Word::Identity }
      it{ is_expected.to be_kind_of Letter }
      it{ expect(subject.methods).to include(:inverse?) }
      it{ expect(subject.inverse?).to be_nil }
      it{ expect(subject.show).to '1' }
      it{ expect(subject).to eq Letter.new }
    end
  end
  #--------------------------------------------------
  describe "Errors" do
    context "InvalidArgument" do
      subject { Element::InvalidArgument.to_s }
      it { is_expected.to eq 'Element::InvalidArgument' }
    end
  end
  #------------------------
  let(:myword) { Word.new(mystr) }
  #------------------------
  describe "when initializing" do
    context "raises no error" do
      subject { myword.show }
      #-----
      shared_examples "is eq to the argument" do
        it { is_expected.to eq mystr }
      end
      #-----
      context "with a string of alphabet" do
        %w[a A x aA xaybzc].each do |c|
          let(:mystr) { c }
          it_behaves_like "is eq to the argument"
        end
      end
      #-----
      context "with the letter '1'" do
        let(:mystr) { '1' }
        it_behaves_like "is eq to the argument"
      end
      #-----
      context "with a String including non-alphabet letters" do
        let(:mystr) { 'Al&p(hab]e$tO8nl0y/' }
        it "excludes non-alphabet letters" do
          is_expected.to eq 'AlphabetOnly'
        end
      end
      #-----
    end
  #   #------------------------
  #   xcontext "raises error" do
  #     shared_examples "Raise Word::InvalidArgument" do |ms|
  #       let(:mystr) { ms }
  #       it { is_expected.to raise_error(Element::InvalidArgument) }
  #     end
  #     subject { lambda { myword } }
  #     #-----
  #     context "without arguments" do
  #       subject { Word.new }
  #       it_behaves_like "Raise Element::InvalidArgument"
  #     end
  #     context "with nil" do
  #       it_behaves_like "Raise Element::InvalidArgument", nil
  #     end
  #     context "with the empty string" do
  #       it_behaves_like "Raise Element::InvalidArgument", ''
  #     end
  #     context "with a String consisting of non-alphabet letters" do
  #       data = ['0', '2', '00', '28302370', '&;/:;*+][', '*3]0:[2+8;']
  #       data.each do |wrong_str|
  #         it_behaves_like "Raise Element::InvalidArgument", wrong_str
  #       end
  #     end
  #     context "with a non-String argument" do
  #       data = [1, 0.238, [1,1,1], 5..10]
  #       data.each do |nonstr|
  #         it_behaves_like "Raise Element::InvalidArgument", nonstr
  #       end
  #     end
  #   end
  end
  # #------------------------

  #------------------------
  describe "#show" do
    let(:mystr) { 'aioStwfmXb' }
    subject { myword.show }
    it { is_expected.to eq mystr }
  end
  #------------------------

  #------------------------
  describe "#gen_at" do
    let(:mystr) { 'aioStwfmXb' }
    #
    context "Integers less than self.length" do
      it "does'nt raise any Exception" do
        expect{ myword.gen_at(0) }.not_to raise_error
        expect{ myword.gen_at(myword.length-1) }.not_to raise_error
      end
      it "return the Letter corresponding with the index in the given word" do
        expect( myword.gen_at(3) ).to be_kind_of Letter
        expect( myword.gen_at(3).show ).to eq mystr[3]
      end
    end
    xcontext "an Integer greater than or equal to self.length" do
      it do
        expect{ myword.gen_at(myword.length) }.to raise_error(Element::InvalidArgument)
        expect{ myword.gen_at(myword.length+1) }.to raise_error(Element::InvalidArgument)
      end
    end
    context "a negative Integer" do
      subject { myword.gen_at(-3) }
      it "does not raise any exception" do
        expect{ lambda{ subject } }.not_to raise_error
        is_expected.to eq Letter.new(myword[-3].show)
      end
    end
    context "0 of the word 1" do
      subject { Word.new('1').gen_at(0) }
      it{ is_expected.to eq Letter.new }
    end
    #
  end
  #------------------------

  #------------------------
  describe "comparisons" do
    let(:mystr) { 'aBAa' }
    #------------------------
    context "==, comparing as Strings," do
      #
      context "comparing a Word to itself" do
        subject { myword == myword }
        it { is_expected.to be_truthy }
      end
      xcontext "comparing a Word to itself contracted" do
        subject { myword == myword.dup.contract }
        it { is_expected.to be_falsy}
      end
      context "comparing a Word with a String" do
        subject { myword.show == 'aBAa' }
        it { is_expected.to be_truthy }
      end
    end
    #------------------------
    xcontext "===, comparing with contraction," do
      subject { myword === myword.dup.contract }
      it { is_expected.to be_truthy }
    end
  end
  #------------------------

  #------------------------
  describe "#set" do
    let(:mystr) {'abC'}
    let(:repstr) {'xoIeRs'}
    #-----
    shared_examples "replace its factors while keeping its object_id" do
      it { is_expected.to eq repstr
        expect{ lambda { subject } }.not_to change{ subject.object_id } }
    end
    #-----
    context "a String in alphabets" do
       subject { myword.set(repstr).to_s }
       it_behaves_like "replace its factors while keeping its object_id"
    end
    context "a Stirng in ascii" do
      subject { myword.set('xo#Ie/9Rs_+:').to_s }
      it_behaves_like "replace its factors while keeping its object_id"
    end
    # context "another Word" do
    #   subject { myword.set(Word.new(repstr)).to_s }
    #   it_behaves_like "replace its factors while keeping its object_id"
    # end
    #-----
    context "neither a Word nor a String" do
      subject { lambda { myword.set(1) } }
      it { is_expected.to raise_error(Element::InvalidArgument) }
    end
  end
#------------------------

#------------------------
describe "#contract" do
  context "in a normal action" do
    context "makes the given word to be reduced expression" do
      %w[aBAa akTcCtKB kTcCtKaBsAaSkKbB].each do |empty|
        let(:mystr) { empty }
        subject { myword.contract }
        it { is_expected.to eq 'aB' }
      end
    end
  end
#
  context "for a product of a word with its inverse" do
    let(:mystr) { 'aBcdE' }
    subject { (myword*myword.invert).contract }
    it { is_expected.to eq Word::Identity }
  end
#
end
#------------------------

#------------------------
describe "#product" do
  let(:mystr) { 'aBc' }
 #
  context "with the identity" do
    it "is the original Word 'aBc'" do
      expect(myword*Word::Identity).to eq myword
      expect(Word::Identity*myword).to eq myword
    end
  end
 #
  context "with another normal Word 'xYz'" do
    subject { myword*Word.new('xYz')}
    it { is_expected.to eq 'aBcxYz'}
  end
 #
  context "with a String" do
    it { expect(myword*'UvW').to eq 'aBcUvW'}
    it "is an instance of Word class" do
      expect(myword*'UvW').to be_a_kind_of Word
      end
    end
#
  context "with a Letter" do
      subject{ myword*Letter.new('g') }
      it { is_expected.to eq 'aBcg' and be_a_kind_of Word }
    end
#
  context "with the inverse" do
    subject { myword*myword.invert}
    it { is_expected.to eq 'aBcCbA'}
  end
 #
end
#------------------------

#------------------------
describe "#invert" do
  context "of a normal Word 'abCd'" do
    subject { Word.new('abCd').invert }
    it { is_expected.to eq 'DcBA' }
  end
#
  context "of a Word of a single letter 'a'" do
    subject { Word.new('a').invert }
    it { is_expected.to eq 'A' }
  end
#
  context "of the identity" do
    subject { Word::Identity.invert }
    it { is_expected.to eq Word::Identity }
  end
#
end
#------------------------

#------------------------
describe "#^ (power)" do
  let(:mystr) { 'bWd' }
  context "with a natural number" do
    subject { myword^3 }
    it { is_expected.to eq 'bWdbWdbWd' }
  end
#
  context "with zero" do
    it "is the identity" do
     ['a', 'A', '1', 'ab', 'abC'].each do |str|
        expect(myword.replace(str)^0).to eq Word::Identity
      end
    end
#
  end
end
#------------------------

#------------------------
describe "#conjugate" do
  before :all do
    @word = Word.new('a')
    @another = Word.new('b')
  end
#
  context "of 'a' with 'b'" do
    subject { @word.conj(@another) }
    it { is_expected.to eq 'Bab' }
  end
#
  context "of @word='aBcde' with @another='dgKy'" do
    subject { (@word.replace('aBcde')).conj(@another.replace('dgKy')) }
    it { is_expected.to eq 'YkGDaBcdedgKy' }
    it "is equal to (@another.invert)*@word*@another" do
      is_expected.to eq (@another.invert)*@word*@another
    end
  end
#
end
#------------------------

#------------------------
describe "generated in a random manner" do
  before do
    @alph = ('a'..'z').to_a + ('A'..'Z').to_a + ['1']
  end
#
  it "raises no error in any method" do
    10.times do |i|
      @mstr = ''
      20.times{ |k| @mstr += @alph[rand(@alph.size)] }
      random_word = Word.new(@mstr)
      (expect do
        random_word.to_s
        random_word.invert
        random_word.replace('qoeEoKlrjfij')
        random_word^5
        random_word.contract
        random_word*random_word
        random_word*(Word.new('abcde'))
        (random_word*random_word.invert).contract
      end).not_to raise_error
    end
  end
end

end

#-------------
#End of File
#-------------
