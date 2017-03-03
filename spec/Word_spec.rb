#
# spec/Word_spec.rb
#
# Time-stamp: <2017-03-03 18:21:06 (ryosuke)>
require('spec_helper')

require('Word.rb')

describe Word do
  #--------------------------------------------------
  describe 'Constants' do
    context 'Identity' do
      subject { Word::Identity }
      it { is_expected.to be_kind_of Letter }
      it { expect(subject.methods).to include(:inverse?) }
      it { expect(subject.inverse?).to be_nil }
      it { expect(subject.show).to '1' }
      it { expect(subject).to eq Letter.new }
    end
  end
  #--------------------------------------------------
  describe 'Errors' do
    context 'InvalidArgument' do
      subject { Element::InvalidArgument.to_s }
      it { is_expected.to eq 'Element::InvalidArgument' }
    end
  end
  #------------------------
  let(:myword) { Word.new(mystr) }
  #------------------------
  describe 'when initializing' do
    context 'raises no error' do
      subject { myword.show }
      #-----
      shared_examples 'is eq to the argument' do
        it { is_expected.to eq mystr }
      end
      #-----
      context 'with a string of alphabet' do
        %w(a A x aA xaybzc).each do |c|
          let(:mystr) { c }
          it_behaves_like 'is eq to the argument'
        end
      end
      #-----
      context "with the letter '1'" do
        let(:mystr) { '1' }
        it_behaves_like 'is eq to the argument'
      end
      #-----
      context 'with a String including non-alphabet letters' do
        let(:mystr) { 'Al&p(hab]e$tO8nl0y/' }
        it 'excludes non-alphabet letters' do
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
  describe '#show' do
    let(:mystr) { 'aioStwfmXb' }
    it { expect { myword.show }.to eq mystr }
    # subject { myword.show }
    # it { is_expected.to eq mystr }
  end
  #------------------------

  #------------------------
  describe '#gen_at' do
    let(:mystr) { 'aioStwfmXb' }
    #
    context 'Integers less than self.length' do
      it "does'nt raise any Exception" do
        expect { myword.gen_at(0) }.not_to raise_error
        expect { myword.gen_at(myword.length - 1) }.not_to raise_error
      end
      it 'return the Letter corresponding with the index in the given word' do
        expect(myword.gen_at(3)).to be_kind_of Letter
        expect(myword.gen_at(3).show).to eq mystr[3]
      end
    end
    xcontext 'an Integer greater than or equal to self.length' do
      it do
        my_err = Element::InvalidArgument
        (0..1).each do |k|
          expect { myword.gen_at(myword.length + k) }.to raise_error(my_err)
        end
      end
    end
    context 'a negative Integer' do
      subject { myword.gen_at(-3) }
      it 'does not raise any exception' do
        expect { lambda { subject } }.not_to raise_error
        is_expected.to eq Letter.new(myword[-3].show)
      end
    end
    context '0 of the word 1' do
      subject { Word.new('1').gen_at(0) }
      it { is_expected.to eq Letter.new }
    end
    #
  end
  #------------------------

  #------------------------
  describe 'comparisons' do
    let(:mystr) { 'aBAa' }
    #------------------------
    context '==, comparing as Strings,' do
      #
      context 'comparing a Word to itself' do
        it { expect(myword == myword).to be_truthy }
      end
      xcontext 'comparing a Word to itself contracted' do
        it { expect(myword == myword.dup.contract).to be_falsy }
      end
      context 'comparing a Word with a String' do
        it { expect(myword.show == 'aBAa').to be_truthy }
      end
    end
    #------------------------
    xcontext '===, comparing with contraction,' do
      it { expect(myword === myword.dup.contract).to be_truthy }
    end
  end
  #------------------------

  #------------------------
  describe '#set' do
    let(:mystr) { 'abC' }
    let(:repstr) { 'xoIeRs' }
    #-----
    shared_examples 'replace its factors while keeping its object_id' do
      it do
        is_expected.to eq repstr
        expect { lambda { subject } }.not_to change { subject.object_id }
      end
    end
    #-----
    context 'a String in alphabets' do
      subject { myword.set(repstr).to_s }
      it_behaves_like 'replace its factors while keeping its object_id'
    end
    context 'a Stirng in ascii' do
      subject { myword.set('xo#Ie/9Rs_+:').to_s }
      it_behaves_like 'replace its factors while keeping its object_id'
    end
    # context "another Word" do
    #   subject { myword.set(Word.new(repstr)).to_s }
    #   it_behaves_like "replace its factors while keeping its object_id"
    # end
    #-----
    context 'neither a Word nor a String' do
      subject { lambda { myword.set(1) } }
      it { is_expected.to raise_error(Element::InvalidArgument) }
    end
  end
#------------------------

#------------------------
  describe '#contract' do
    context 'in a normal action' do
      context 'makes the given word to be reduced expression' do
        %w(aBAa akTcCtKB kTcCtKaBsAaSkKbB).each do |empty|
          let(:mystr) { empty }
          it { expect(myword.contract).to eq 'aB' }
        end
      end
    end
  #
    context 'for a product of a word with its inverse' do
      let(:mystr) { 'aBcdE' }
      subject { (myword * myword.invert).contract }
      it { is_expected.to eq Word::Identity }
    end
  #
  end
#------------------------

#------------------------
  describe '#product' do
    let(:mystr) { 'aBc' }
   #
    context 'with the identity' do
      it "is the original Word 'aBc'" do
        expect(myword * Word::Identity).to eq myword
        expect(Word::Identity * myword).to eq myword
      end
    end
   #
    context "with another normal Word 'xYz'" do
      subject { myword * Word.new('xYz') }
      it { is_expected.to eq 'aBcxYz' }
    end
   #
    context 'with a String' do
      it { expect(myword * 'UvW').to eq 'aBcUvW' }
      it 'is an instance of Word class' do
        expect(myword * 'UvW').to be_a_kind_of Word
      end
    end
  #
    context 'with a Letter' do
      subject { myword * Letter.new('g') }
      it { is_expected.to(eq 'aBcg') && be_a_kind_of(Word) }
    end
  #
    context 'with the inverse' do
      subject { myword * myword.invert }
      it { is_expected.to eq 'aBcCbA' }
    end
   #
  end
#------------------------

#------------------------
  describe '#invert' do
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
    context 'of the identity' do
      subject { Word::Identity.invert }
      it { is_expected.to eq Word::Identity }
    end
  #
  end
#------------------------

#------------------------
  describe '#^ (power)' do
    let(:mystr) { 'bWd' }
    context 'with a natural number' do
      subject { myword ^ 3 }
      it { is_expected.to eq 'bWdbWdbWd' }
    end
  #
    context 'with zero' do
      it 'is the identity' do
        %w(a A 1 ab abC).each do |str|
          expect(myword.replace(str) ^ 0).to eq Word::Identity
        end
      end
  #
    end
  end
#------------------------

#------------------------
  describe '#conjugate' do
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
      it 'is equal to (@another.invert)*@word*@another' do
        is_expected.to eq (@another.invert) * @word * @another
      end
    end
  #
  end
#------------------------

#------------------------
  describe 'generated in a random manner' do
    before do
      @alph = ('a'..'z').to_a + ('A'..'Z').to_a + ['1']
    end
    #
    let(:myword) { Word.new('abcde') }
    it 'raises no error in any method' do
      10.times do
        @mstr = ''
        20.times { @mstr += @alph[rand(@alph.size)] }
        random_word = Word.new(@mstr)
        (expect do
          random_word.to_s
          random_word.invert
          random_word.replace('qoeEoKlrjfij')
          random_word ^ 5
          random_word.contract
          random_word * random_word
          random_word * myword
          (random_word * random_word.invert).contract
        end).not_to raise_error
      end
    end
  end
end

#-------------
# End of File
#-------------
