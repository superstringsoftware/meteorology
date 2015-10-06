chai = require 'chai'
chai.should()
describe 'Task instance', ->
  task1 = task2 = null
  it 'should have a name', ->
    task1 = new Task 'feed the cat'
    task1.name.should.equal 'feed the cat'